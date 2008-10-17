# =============================================================================
# = Sequences                                                                 =
# =============================================================================
Factory.sequence(:email) { |n| "user#{n}@example.com" }

# =============================================================================
# = Definitions                                                               =
# =============================================================================
Factory.define(:address, :class => Address) do |address|
  address.name 'Bob Loblaw'
  address.line_one '123 Main St.'
  address.line_two 'Anytown, GA'
  address.country 'United States'
  address.email 'bob@example.com'
end

Factory.define(:cart) do |cart|
end

Factory.define(:item) do |item|
  item.quantity 1
  item.association :variant
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
  variant.name '10-pack'
  variant.cents 1000
  variant.currency 'USD'
end
