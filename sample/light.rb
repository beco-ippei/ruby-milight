require "#{File.dirname(File.absolute_path __FILE__)}/../lib/bulb"

ipaddr = ENV['IPADDR']
port = (ENV['PORT'] || 8899).to_i
bulb = Bulb.new ipaddr, port

cmd = ARGV.shift
val = ARGV.shift

case cmd.downcase
when 'on'
  bulb.on
when 'off'
  bulb.off
when 'color'
  bulb.send val.to_sym
when 'color-list'
  puts Bulb::Color.constants
    .map(&:downcase).join ', '
when 'bright'
  bulb.brightness = val.to_i
when 'night'
  bulb.night
end

