# We got this data from http://ip-to-country.webhosting.info/downloads/ip-to-country.csv.zip
# See http://ip-to-country.webhosting.info/node/view/5 for more info.
class Locator < ActiveRecord::Base
  # TODO should this be a class method find(:first)?
  named_scope :ip_address, lambda {|ip_address| {
    :conditions => ['ip_from <= ? AND ip_to >= ?', ip_address, ip_address] }}

  def self.convert(string)
    string.to_s.split('.').map { |part| part.to_i.to_s(16) }.join.to_i(16)
  end

  def self.country_code(string)
    record = ip_address(convert(string)).first
    record.converted_country_code if record
  end

  def converted_country_code
    country_code == 'GB' ? 'uk' : country_code.downcase
  end
end
