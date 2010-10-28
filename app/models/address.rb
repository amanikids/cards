class Address < ActiveRecord::Base
  attr_accessible :name
  attr_accessible :line_1
  attr_accessible :line_2
  attr_accessible :line_3
  attr_accessible :line_4
  attr_accessible :country

  validates :name,    :presence => true
  validates :line_1,  :presence => true
  validates :line_2,  :presence => true
  validates :country, :presence => true

  class << self
    def from_paypal_details(d)
      new.tap do |address|
        address.name    = d['name']
        address.line_1  = d['address1']
        address.line_2  = d['address2']
        address.line_3  = "#{d['city']}, #{d['state']} #{d['zip']}"
        address.country = d['country']
      end
    end
  end
end
