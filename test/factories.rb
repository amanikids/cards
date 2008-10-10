Factory.sequence(:email) { |n| "user#{n}@example.com" }

Factory.define(:item) do |item|
  item.association :order
  item.association :variant
end

Factory.define(:order) do |order|
end

Factory.define(:product) do |product|
  product.name "This Year's Card"
end

Factory.define(:user) do |user|
  user.email Factory.next(:email)
  user.password 'foo'
end

Factory.define(:variant) do |variant|
  variant.association :product
  variant.price_amount 10
  variant.price_currency 'USD'
end