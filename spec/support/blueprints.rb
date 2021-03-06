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
  name    { Faker::Name.name }
  line_1  { Faker::Address.street_address }
  line_2  { Faker::Address.city_state_zip }
  country { 'United States' }
  email   { Faker::Internet.email }
end

Administratorship.blueprint do
  user
end

Cart.blueprint do
  store
end

Cart.blueprint(:shipped) do
  items(2, :shipped)
end

Cart.blueprint(:unshipped) do
  items(2, :unshipped)
end

Distributorship.blueprint do
  store
  user
end

Item.blueprint do
  cart
  packaging
  quantity { 1 }
end

Item.blueprint(:shipped) do
  shipped_at { Time.zone.now }
end

Item.blueprint(:unshipped) do
  shipped_at { nil }
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
  cart(:shipped)
end

Order.blueprint(:unshipped) do
  cart(:unshipped)
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
  name  { Faker::Name.name }
  description { Faker::Lorem.sentence }
  image_path { '2010/poinsettia.jpg' }
  store
end

Store.blueprint do
  account     { PaypalAccount.make }
  active      { true }
  currency    { 'USD' }
  description { Faker::Lorem.sentence }
  name        { Faker::Address.city }
  slug        { Faker.letterify('??') }
end

Transfer.blueprint do
  product
  happened_at { Date.today }
  quantity    { 5000 }
  reason      { 'Printing' }
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
