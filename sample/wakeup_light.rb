$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)

require 'milight'

ipaddr = ENV['IPADDR']
interval = 3 * 60     # 3min

bulb = Milight::Bulb.new ip: ipaddr

if ARGV[0] == 'prepare'
  puts 'prepare for wakeup-light'
  [:on, :dark, :lime_green, :off].each do |cmd|
    bulb.send(cmd)
    sleep 2
  end
  exit
end

# light on (night-mode)
[
  [:night],
  [:on, :dark, :lime_green],
  [[:bright, 10]],
  [[:bright, 20]],
  [:white],
  [[:bright, 30]],
  [:full_bright],
  [:disco],
].each do |commands|
  commands.each do |cmd|
    bulb.send(*cmd)
    sleep 1.5
  end
  sleep interval
end

sleep 10 * 60   # 10min
bulb.dark
sleep 2
bulb.off

