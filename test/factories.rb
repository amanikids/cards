# =============================================================================
# = Sequences                                                                 =
# =============================================================================

# Use base 36 to get a boat load of unique country codes, otherwise we run out
Factory.sequence(:country_code) { |n| (n + 36).to_s(36) }

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

Factory.define(:batch) do |batch|
  batch.association :distributor
end

Factory.define(:cart) do |cart|
  cart.association :distributor
end

Factory.define(:distributor) do |distributor|
  distributor.country_code { Factory.next(:country_code) }
  distributor.currency 'USD'
  distributor.email { Factory.next(:email) }
  distributor.password 'foo'
  distributor.name { Faker::Name.name }
  distributor.country { ["United States", "Canada", "United Kingdom", "Germany", "Mexico"].rand }
end

Factory.define(:donation) do |donation|
  donation.created_at 2.days.ago
  donation.received_at 47.hours.ago
  donation.association :order
  donation.association :donation_method
end

Factory.define(:donation_method) do |method|
  method.name 'check'
end

Factory.define(:inventory) do |inventory|
  inventory.initial 300
  inventory.association :distributor
  inventory.association :product
end

Factory.define(:item) do |item|
  item.quantity { (1..5).to_a.rand }
  item.association :variant
end

Factory.define(:list) do |list|
  list.association :distributor
end

Factory.define(:order) do |order|
  order.created_at 3.days.ago
  order.token '6bcc3f7303a4675e3c33f84bbd33e245cc770921'
  order.association :address
  order.association :distributor
end

Factory.define(:paypal_donation_method, :class => DonationMethod) do |method|
  method.name 'paypal'
end

Factory.define(:product) do |product|
  product.name "This Year's Card"
end

Factory.define(:user) do |user|
  user.email { Factory.next(:email) }
  user.password 'foo'
end

Factory.define(:variant) do |variant|
  variant.cents 1000
  variant.currency 'USD'
  variant.name ''
  variant.size { [10, 25].rand }
  variant.association :product
end
