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

Then /^order (.*) should be cancelled$/ do |token|
  assert_nil Order.find_by_token(token)
  Then %{I should see "Order cancelled. An email has been sent to the Donor."}
end

Given /^the following distributors exists:$/ do |table|
  table.hashes.each do |distributor|
    Factory.create(:distributor,
      :name    => distributor["Name"],
      :country => distributor["Country"]
    )
  end
end

Then /^order "([^\"]*)" should belong to "([^\"]*)"$/ do |token, name|
  order = Order.find_by_token(token)
  assert_equal name, order.distributor.name

  order.items.reject(&:on_demand?).collect(&:batch).each do |batch|
    assert_equal name, batch.distributor.name
  end
end
