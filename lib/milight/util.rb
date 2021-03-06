module Milight
  module Util
    def self.current_ipaddr
      matched = /inet\ addr:([0-9\.]*)/.match wlan_config
      matched[1] if matched
    end

    def self.broadcast_addr
      matched = /Bcast:([0-9\.]*)/.match wlan_config
      matched[1] if matched
    end

    private

    #TODO: modularize for env/os.
    def self.wlan_config
      %x[LANG=C ifconfig wlan]
    end
  end
end

