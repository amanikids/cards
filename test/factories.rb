Factory.sequence(:email) { |n| "user#{n}@example.com" }

Factory.define(:card) do |card|
  card.name "This Year's Card"
end

Factory.define(:item) do |item|
  item.association :order
  item.association :card
end

Factory.define(:order) do |order|
end

Factory.define(:user) do |user|
  user.email Factory.next(:email)
  user.password 'foo'
end