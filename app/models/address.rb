class Address < ActiveRecord::Base
  attr_accessible :name
  attr_accessible :line_1
  attr_accessible :line_2
  attr_accessible :line_3
  attr_accessible :line_4
  attr_accessible :country
  attr_accessible :email

  validates :name,    :presence => true
  validates :line_1,  :presence => true
  validates :line_2,  :presence => true
  validates :country, :presence => true
  validates :email,   :presence => true

  class << self
    def from_paypal_details(email, d)
      city_state = [d['city'], d['state']].select(&:present?).join(', ')

      new.tap do |address|
        address.name    = d['name']
        address.line_1  = d['address1']

        if d['address2'].present?
          address.line_2 = d['address2']
          address.line_3 = city_state
          address.line_4 = d['zip']
        else
          address.line_2 = city_state
          address.line_3 = d['zip']
        end

        address.country = d['country']
        address.email   = email
      end
    end
  end
end
