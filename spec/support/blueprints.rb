require 'machinist/active_record'

Machinist.configure do |config|
  config.cache_objects = false
end

class Faker::Address
  class << self
    def city_state_zip
      "#{city}, #{us_state_abbr} #{zip_code}"
    end
  end
end

Address.blueprint do
  name   { Faker::Name.name }
  line_1 { Faker::Address.street_address }
  line_2 { Faker::Address.city_state_zip }
  country { 'United States' }
end

Cart.blueprint do
  store
end

Item.blueprint do
  cart
  product
  quantity { 1 }
end

Order.blueprint do
  address
  cart
  payment { PaypalPayment.make }
end

Order.blueprint(:shipped) do
  shipped_at { Time.zone.now }
end

Order.blueprint(:unshipped) do
  shipped_at { nil }
end

PaypalAccount.blueprint do
  login     { Faker::Internet.email }
  password  { Faker.letterify('????????') }
  signature { Faker.letterify('????????????????????????????????') }
end

PaypalPayment.blueprint do
  payer_id { Faker::Internet.email }
  token    { 42 }
end

Product.blueprint do
  name  { Faker::Name.first_name }
  price { 10 }
end

Store.blueprint do
  name           { Faker::Address.city }
  slug           { Faker.letterify('??') }
  currency       { 'USD' }
  distributor    { User.make }
  paypal_account { PaypalAccount.make }
end

User.blueprint do
  email    { Faker::Internet.email }
  password { ActiveSupport::SecureRandom.hex(64) }
end
