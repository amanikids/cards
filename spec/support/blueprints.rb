require 'machinist/active_record'

Product.blueprint do
  name  { Faker::Name.first_name }
  price { 1000 }
end

User.blueprint do
  email { Faker::Internet.email }
end
