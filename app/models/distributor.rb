class Distributor < User
  validates_presence_of :country_code, :currency
end