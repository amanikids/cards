Order.transaction do
  100.times do
    distributor = Distributor.all.rand

    all_purchasable_products = distributor.products + Product.on_demand

    order = Order.new(
      :address => Address.new(
        :name     => Faker::Name.name,
        :email    => Faker::Internet.email,
        :line_one => Faker::Address.street_address,
        :line_two => Faker::Address.city,
        :country  => %w(UK AU US TZ).rand), # TODO faker?
      :distributor => distributor,
      :additional_donation_amount => (rand(2) == 1 ? 0 : rand(100)))

    (1..3).to_a.rand.times do
      order.items.build(
        :variant  => all_purchasable_products.collect(&:variants).flatten.rand,
        :quantity => (1..5).to_a.rand)
    end

    order.save!

    Batch.find_each do |batch|
      #batch.update_attributes!(:shipped_at => 1.day.ago) if rand(3) > 0
    end
  end
end
