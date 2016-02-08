require 'socket'
require 'ipaddr'

module Milight
  class Bulb
    def initialize(group: :all, ip: nil, port: 8899)
      self.group = group
      self.ip = ip
      @port = port

      @debugger = lambda {|_| }
    end

    #TODO: move to anywhere...
    def debugger=(type)
      @debugger = case type
                  when :puts
                    lambda {|msg|
                      puts " - debug :: #{msg}"
                    }
                  else
                    lambda {|_| }
                  end
      debug "set debug - #{type}"
    end

    def debug(msg)
      @debugger.call msg
    end

    def on
      command Command::LED_ON[@group]
    end

    def disco
      command Command::DISCO_MODE
    end

    def off
      command Command::LED_OFF[@group]
    end

    # white-command 100ms followed by 'on-command'
    def white
      self.on
      command Command::WHITE[@group]
    end

    # night-command 100ms followed by 'off-command'
    def night
      self.off
      command Command::NIGHT[@group]
    end

    # for colors
    Color.constants.each do |color|
      color_name = color.downcase
      define_method color_name.to_sym do
        color_code = defined_color color
        self.on
        command Command::SET_COLOR, color_code
      end
    end

    def color_value=(val)
      if code = color_code(val)
        self.on
        command Command::SET_COLOR, code
      else
        debug "invalid color value '#{val}'"
      end
    end

    def bright(persent)
      if val = brightness(persent.to_i)
        self.on
        command Command::BRIGHTENESS, val
      else
        debug "invalid persent value '#{persent}'"
      end
    end

    def full_bright
      self.bright 50
    end

    def dark
      self.bright 0
    end

    private

    def ip=(ipaddr)
      unless ipaddr
        raise "ip is not allowed nil"
      end
      IPAddr.new ipaddr   # just validate
      @ipaddr = ipaddr
    end

    def group=(group)
      if group == :all
        @group = :all
      elsif (1..5).cover? group
        @group = "group#{group}".to_sym
      else
        raise 'invalid group. use :all or 1..5'
      end
    end

    def brightness(persent)
      return nil unless (0..100).cover?(persent)
      sprintf(
        '%02d',
        2 + 25 * persent.to_i / 100
      )
    end

    def defined_color(method)
      name = method.upcase.to_sym
      if Color.constants.include? name
        Color.const_get(name)
      else
        nil
      end
    end

    # parse color code ("00" .. "ff")
    # valid color-value is 0..255
    def color_code(val)
      if val.is_a? String
        code = val
        val = code.hex
        val = -1 if val == 0 && code != '00'
      elsif val.is_a? Fixnum
        code = val
        val = val.to_i
        code = '%02x' % val
      else
        return nil
      end

      if (0..255).cover? val
        code
      else
        nil
      end
    end

    def command(cmd, value = '00')
      debug "cmd : #{cmd} / #{value}"
      msg = message cmd, value

      #TODO: initialize first ?
      sock = UDPSocket.open
      sock.setsockopt(
        Socket::SOL_SOCKET,
        Socket::SO_BROADCAST,
        1
      )
      sock.send(msg, 0, @ipaddr, @port)
    end

    def message(cmd, value)
      [cmd, value, "55"].map(&:to_s)
        .map(&:hex).pack "C*"
    end
  end
end
