class Locator
  class AlwaysUnitedStates
    def country_code(*args)
      'us'
    end
  end

  class WebLookup
    require 'open-uri'

    def initialize(url="http://api.hostip.info/country.php?ip=%s")
      @url = url
    end

    def country_code(ip_address)
      Rails.logger.debug("Looking up country_code for #{ip_address} at #{@url % ip_address}.")

      returning lookup_country_code(ip_address) do |country_code|
        Rails.logger.debug("Found #{country_code} for #{ip_address}.")
      end
    end

    private

    def lookup_country_code(ip_address)
      open(@url % ip_address) { |io| io.read.strip.downcase }
    end
  end

  @@service = WebLookup.new
  cattr_accessor :service

  def self.country_code(ip_address)
    service.country_code(ip_address)
  end
end