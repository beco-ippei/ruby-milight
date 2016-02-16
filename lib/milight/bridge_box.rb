require 'milight'
require 'readline'
require "socket"

module Milight::BridgeBox
  MILIGHT_WIFI = /^10\.10\.100\.[0-9]+$/
  SERVER_IP = '10.10.100.254'
  RECEIVE_IP = "0.0.0.0"
  PORT = '48899'

  def self.setup
    puts "-- Please connect wifi 'milight_XXXXXXX'."

    if self.wait_connection true
      puts '... milight connected.'
    else
      puts <<DESC
  milight wifi connection timeout (1min)
  if milight wifi not found, initialize your controller box.
DESC
      exit 1
    end

    sock = self.socket

    t1 = Thread.new do
      self.wait_wscan_results
    end

    sleep 1
    puts '-- send command: WSCAN ....'
    sock.command "Link_Wi-Fi"
    sock.command "+ok"
    sock.command "AT+WSCAN\r"

    t1.join

    wlans = t1.value.split "\n"

    wlans.shift   # ignore header
    ssids = wlans.map do |line|
      ch, ssid, _, sec, _ = line.split ','
      if ssid.is_a?(String) && ssid.length > 1
        {ch: ch, ssid: ssid, sec: sec}
      end
    end.compact

    ssid = self.choice_ssid ssids
    puts "-- set wifi SSID : '#{ssid[:ssid]}'"
    sock.command "AT+WSSSID=#{ssid[:ssid]}\r"

    key = self.security_key
    puts "-- set wifi security key : '#{key}'"
    sock.command "AT+WSKEY=WPA2PSK,AES,#{key}\r"

    sock.command "AT+WMODE=STA\r"
    sock.command "AT+Z\r"
    sock.command "AT+Q\r"

    sock.close


    if self.wait_connection false
      puts <<DESC
  ... miligt wifi disconnected.
  check your controller box led!

DESC
    else
      puts ' milight wifi connection still connected'
      exit 1
    end
  end

  def self.wait_connection(milight = true)
    20.times do
      sleep 3
      if ipaddr = Milight::Util.current_ipaddr
        print '.'
      else
        print '-'
      end

      if self.milight_wifi?(ipaddr) == milight
        return true
      end
    end
    false
  end

  def self.milight_wifi? ipaddr
    !(ipaddr && MILIGHT_WIFI =~ ipaddr).nil?
  end

  def self.socket
    sock = UDPSocket.open
    sock.setsockopt(
      Socket::SOL_SOCKET,
      Socket::SO_BROADCAST,
      1
    )
    def sock.command msg
      self.send msg, 0, SERVER_IP, PORT
    end
    sock
  end

  def self.wait_wscan_results
    puts '-- waiting receive response: WSCAN ....'
    rsock = UDPSocket.new
    rsock.bind(RECEIVE_IP, PORT)
    string = nil

    sel = IO::select([rsock])
    if sel != nil
      sel[0].each do |s|
        data = s.recvfrom_nonblock(65535)
        string = data[0].chomp!
      end
    else
      puts '-- not received ....'
      exit 1
    end
    rsock.close
    string.gsub(/\+ok=\n/, '')
  end

  def self.choice_ssid ssids
    puts '', '-'*20
    puts " no: 'ssid' (security types)"
    ssids.each.with_index do |s, idx|
      num = '%#2d' % (idx+1)
      puts " #{num}: '#{s[:ssid]}' (#{s[:sec]})"
    end
    puts '-'*20, ''
    puts <<-DESC
      Choise your SSID(no).
      but if your Access point not found, restart app
    DESC

    while true
      msg = ">> input your SSID no(1-#{ssids.size-1}) > "
      num = Readline.readline(msg).chomp.to_i
      if num == 0
        next      # 0 or nil (not a number)
      elsif !(1..ssids.size).cover? num
        puts <<-MSG
          invalid number : '#{num}'
          exit.
        MSG
        exit 0
      end
      return ssids[num-1]
    end
  end

  def self.security_key
    while true
      msg = '>> Input security key > '
      key = Readline.readline(msg).chomp
      if key != ""
        return key
      end
    end
  end

end

