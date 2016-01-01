require 'socket'

class Bulb
  module Command
    SET_COLOR = '40'
    LED_ALL_OFF = '41'
    LED_ALL_ON = '42'
    DISCO_SPEED_SLOWER = '43'
    DISCO_SPEED_FASTER = '44'

    BRIGHTENESS = '4E'
  end

  module Color
    VIOLET = '00'
    ROYAL_BLUE = '10'
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
    puts "set debug - #{type}"
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

  def bright(persent)
    if val = brightness(persent.to_i)
      command Bulb::Command::BRIGHTENESS, val
    else
      debug "invalid persent value '#{persent}'"
    end
  end

  # for colors
  def method_missing(method, *args)
    color = defined_color method
    if color
      command Bulb::Command::SET_COLOR, color
    end
  end

  private

  def brightness(persent)
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
