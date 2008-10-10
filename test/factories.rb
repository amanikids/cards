Factory.sequence(:email) { |n| "user#{n}@example.com" }

Factory.define(:product) do |product|
  product.name "This Year's Card"
end

Factory.define(:item) do |item|
  item.association :order
  item.association :product
end

Factory.define(:order) do |order|
end

Factory.define(:user) do |user|
  user.email Factory.next(:email)
  user.password 'foo'
end