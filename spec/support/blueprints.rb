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
  packaging
  quantity { 1 }
end

JustgivingAccount.blueprint do
  charity_identifier { 42 }
end

JustgivingPayment.blueprint do
  donation_identifier { 42 }
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

Packaging.blueprint do
  name  { Faker::Name.first_name }
  price { 1000 }
  product
  size  { 10 }
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
  name  { 'Poinsettia' }
  description { Faker::Lorem.sentence }
  image_path { '2010/poinsettia.jpg' }
  store
end

Store.blueprint do
  account     { PaypalAccount.make }
  currency    { 'USD' }
  description { Faker::Lorem.sentence }
  distributor { User.make }
  name        { Faker::Address.city }
  slug        { Faker.letterify('??') }
end

# Pre-calculate the password hash once, to make specs significantly faster.
# NOTE that this does mean some specs / features need to know that we're using
# "secret" as the password here. I think the regained speed's probably worth
# the trade-off.
SECRET_PASSWORD = BCrypt::Password.create('secret')

User.blueprint do
  email         { Faker::Internet.email }
  password_hash { SECRET_PASSWORD }
end
