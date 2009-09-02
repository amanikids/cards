require 'faker'

Order.transaction do
  100.times do
    distributor = Distributor.all.rand

    order = Order.create!(
      :address => Address.create!(
        :name     => Faker::Name.name,
        :email    => Faker::Internet.email,
        :line_one => Faker::Address.street_address,
        :line_two => Faker::Address.city,
        :country  => %w(UK AU US TZ).rand), # TODO faker?
      :distributor => distributor,
      :additional_donation_amount => (rand(2) == 1 ? 0 : rand(100)))

    (1..3).to_a.rand.times do
      order.items.create!(
        :variant  => distributor.products.collect(&:variants).flatten.rand,
        :quantity => (1..5).to_a.rand)
    end

    order.create_shipment if rand(3) > 0
  end
end
