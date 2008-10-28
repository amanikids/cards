class Distributor < User
  has_many :carts
  has_many :distributor_donation_methods
  has_many :donation_methods, :through => :distributor_donation_methods, :order => :position
  has_many :orders

  validates_presence_of :country_code, :currency

  def to_param
    country_code
  end
end