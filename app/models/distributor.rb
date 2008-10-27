class Distributor < User
  has_many :carts
  has_many :orders

  validates_presence_of :country_code, :currency
end