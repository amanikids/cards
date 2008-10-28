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
  cart.association :distributor
end

Factory.define(:distributor) do |distributor|
  distributor.country_code 'us'
  distributor.currency 'USD'
  distributor.email { Factory.next(:email) }
  distributor.password 'foo'
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

Factory.define(:download) do |cart|
end

Factory.define(:downloadable_item, :class => Item) do |item|
  item.quantity 1
  item.association :variant, :factory => :variant_with_download
end

Factory.define(:inventory) do |inventory|
  inventory.quantity 300
  inventory.association :distributor
  inventory.association :sku
end

Factory.define(:item) do |item|
  item.quantity 1
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

Factory.define(:shipment) do |shipment|
  shipment.created_at 1.day.ago
  shipment.association :order
end

Factory.define(:sku) do |sku|
  sku.name 'the blue one'
  sku.association :product
end

Factory.define(:system_user) do |system_user|
  system_user.email { Factory.next(:email) }
  system_user.password 'foo'
end

Factory.define(:user) do |user|
  user.email { Factory.next(:email) }
  user.password 'foo'
end

Factory.define(:variant) do |variant|
  variant.cents 1000
  variant.currency 'USD'
  variant.size 5
  variant.association :sku
end

Factory.define(:variant_with_download, :class => Variant) do |variant|
  variant.cents 1000
  variant.currency 'USD'
  variant.association :sku
  variant.association :download
end
