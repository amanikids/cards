require 'machinist/active_record'

Machinist.configure do |config|
  config.cache_objects = false
end

Cart.blueprint do
end

Item.blueprint do
  cart
  product
  quantity { 1 }
end

Order.blueprint do
  cart
  payment
end

Payment.blueprint do
  details { PayPalPaymentDetails.make }
end

PayPalAccount.blueprint do
  login     { Faker::Internet.email }
  password  { Faker.letterify('????????') }
  signature { Faker.letterify('????????????????????????????????') }
end

PayPalPaymentDetails.blueprint do
  payer_id { Faker::Internet.email }
  token    { 42 }
end

Product.blueprint do
  name  { Faker::Name.first_name }
  price { 10 }
end

User.blueprint do
  email { Faker::Internet.email }
end
