require "#{File.dirname(File.absolute_path __FILE__)}/../lib/bulb"

ipaddr = ENV['IPADDR']
port = (ENV['PORT'] || 8899).to_i
interval = 3 * 60     # 3min

bulb = Bulb.new ipaddr, port

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
  [:dark],
].each do |commands|
  commands.each do |cmd|
    bulb.send(*cmd)
    sleep 1.5
  end
  sleep interval
end

