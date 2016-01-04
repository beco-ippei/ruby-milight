require 'socket'

class Bulb
  module Command
    SET_COLOR = '40'
    LED_ALL_OFF = '41'
    LED_ALL_ON = '42'
    DISCO_SPEED_SLOWER = '43'
    DISCO_SPEED_FASTER = '44'

    BRIGHTENESS = '4E'

    WHITE = 'C2'
  end

  module Color
    VIOLET = '00'
    ROYAL_BLUE = '10'
    BLUE = ROYAL_BLUE     # alias
    BABY_BLUE = '20'
    AQUA = '30'
    MINT = '40'
    SEAFOAM_GREEN = '50'
    GREEN = '60'
    LIME_GREEN = '70'
    YELLOW = '80'
    YELLOW_ORANGE = '90'
    ORANGE = 'a0'
    RED = 'b0'
    PINK = 'c0'
    WHITE = 'c2'
    FUSIA = 'd0'
    LILAC = 'e0'
    LAVENDAR = 'f0'
  end

  def initialize(ip_address, port)
    @ipaddr = ip_address
    @port = port
    @debugger = lambda {|_| }
  end

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
    command Bulb::Command::LED_ALL_ON
  end

  def off
    command Bulb::Command::LED_ALL_OFF
  end

  def white
    command Bulb::Command::LED_ALL_ON
    # white-command 100ms followed by 'on-command'
    command Bulb::Command::WHITE
  end

  def color_value=(val)
    if code = color_code(val)
      command Bulb::Command::SET_COLOR, code
    else
      debug "invalid color value '#{val}'"
    end
  end

  def brightness=(persent)
    if val = brightness_code(persent.to_i)
      command Bulb::Command::BRIGHTENESS, val
    else
      debug "invalid persent value '#{persent}'"
    end
  end

  def bright
    self.brightness = 100
  end

  def dark
    self.brightness = 0
  end

  private

  # for colors
  def method_missing(method, *args)
    color = defined_color method
    if color
      command Bulb::Command::SET_COLOR, color
    else
      raise "undefined method `#{method}'"
    end
  end

  def brightness_code(persent)
    return nil unless (0..100).cover?(persent)
    sprintf(
      '%02d',
      2 + 25 * persent.to_i / 100
    )
  end

  def defined_color(method)
    name = method.upcase.to_sym
    if Bulb::Color.constants.include? name
      Bulb::Color.const_get(name)
    else
      nil
    end
  end

  # parse color code ("00" .. "ff")
  # valid color-value is 0..255
  def color_code(val)
    case val.class
    when String
      code = val
      val = code.hex
      val = -1 if val == 0 && code != '00'
    when Fixnum
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
