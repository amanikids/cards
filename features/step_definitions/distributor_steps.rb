Given /^I am logged in as a distributor for order (.*)$/ do |token|
  distributor = Order.find_by_token(token).distributor
  visit('/distributors')
  fill_in("Email",    :with => distributor.email)
  fill_in("Password", :with => 'foo')
  click_button("Log in")
end

Given /^a new shipment exists for an order with token (.*)$/ do |token|
  @distributor ||= Factory.create(:distributor, :password => 'foo')
  batch = Factory.create(:batch, :distributor => @distributor)
  Factory.create(:item, :batch => batch, :list => Factory.create(:order))
  batch.items(true)
  batch.order.token = token
  batch.order.distributor = @distributor
  batch.order.save!
  batch.items.each do |item|
    Factory.create(:inventory, :product => item.product, :distributor => @distributor)
  end
end

Then /^my shipment for order (.*) should be shipped$/ do |token|
  order = Order.find_by_token(token)
  order.items.collect(&:batch).select {|b| b.distributor == @distributor }.all?(&:shipped?)
  Then %{I should see "This shipment was sent"}
end
