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

Factory.define(:list) do |list|
end

Factory.define(:order) do |order|
  order.created_at 3.days.ago
  order.token '6bcc3f7303a4675e3c33f84bbd33e245cc770921'
  order.association :address
end

Factory.define(:payment) do |payment|
  payment.created_at 2.days.ago
  payment.received_at 47.hours.ago
  payment.association :order
  payment.association :payment_method
end

Factory.define(:payment_method) do |method|
  method.name 'check'
end

Factory.define(:paypal_payment_method, :class => PaymentMethod) do |method|
  method.name 'paypal'
end

Factory.define(:product) do |product|
  product.name "This Year's Card"
end

Factory.define(:shipment) do |shipment|
  shipment.created_at 1.day.ago
  shipment.association :order
  shipment.association :shipper, :factory => :user
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
