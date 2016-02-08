$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)

require 'milight'

ipaddr = ENV['IPADDR']

group = (g = ARGV.shift) == 'all' ? :all : g.to_i
bulb = Milight::Bulb.new ip: ipaddr, group: group

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
  puts Milight::Color.constants
    .map(&:downcase).join ', '
when 'bright'
  bulb.brightness = val.to_i
when 'night'
  bulb.night
end

