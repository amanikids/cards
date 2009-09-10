# We got this data from http://ip-to-country.webhosting.info/downloads/ip-to-country.csv.zip
# See http://ip-to-country.webhosting.info/node/view/5 for more info.
class Locator < ActiveRecord::Base
  named_scope :ip_address, lambda {|ip_address| {
    :conditions => ['ip_from <= ? AND ip_to >= ?', ip_address, ip_address] }}

  def self.convert(string)
    IPAddr.new(string).to_i
  rescue ArgumentError
    0
  end

  def self.country_code(string)
    record = ip_address(convert(string)).first
    record.converted_country_code if record
  end

  def converted_country_code
    country_code == 'GB' ? 'uk' : country_code.downcase
  end
end
