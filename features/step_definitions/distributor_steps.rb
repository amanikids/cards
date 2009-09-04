Given /^I am logged in as a distributor for order (.*)$/ do |token|
  @distributor = Order.find_by_token(token).distributor
  visit('/distributors')
  fill_in("Email",    :with => @distributor.email)
  fill_in("Password", :with => 'foo')
  click_button("Log in")
end

Given /^a new shipment exists for an order with token (.*)$/ do |token|
  distributor = Factory.create(:distributor, :password => 'foo')
  batch = Factory.create(:batch, :distributor => distributor)
  Factory.create(:item, :batch => batch, :list => Factory.create(:order))
  batch.items(true)
  batch.order.token = token
  batch.order.distributor = distributor
  batch.order.save!
  batch.items.each do |item|
    Factory.create(:inventory, :product => item.product, :distributor => distributor)
  end
end

Then /^my shipment for order (.*) should be shipped$/ do |token|
  order = Order.find_by_token(token)
  assert order.batches.detect {|b| b.distributor == @distributor }.shipped?
  Then %{I should see "This batch was shipped"}
end

Then /^my shipment for order (.*) should not be shipped$/ do |token|
  order = Order.find_by_token(token)
  assert !order.batches.detect {|b| b.distributor == @distributor }.shipped?
  Then %{I should see "This batch has not yet been shipped"}
end

Then /^order (.*) should be cancelled$/ do |token|
  assert_nil Order.find_by_token(token)
  Then %{I should see "Order cancelled. An email has been sent to the Donor."}
end

Given /^the donor has indicated they made a donation for order "([^\"]*)"$/ do |token|
  order = Order.find_by_token(token)
  Factory.create(:donation,
    :received_at => nil,
    :order       => order)
end

Then /^the received at date for order "([^\"]*)" should be today$/ do |token|
  order = Order.find_by_token(token)
  assert_equal Date.today, order.donation_received_at.to_date
end

When /^I visit the first batch for order "([^\"]*)"$/ do |token|
  order = Order.find_by_token(token)
  batch = order.items.first.batch
  visit(batch_path(batch))
end

Then /^I should be redirected to my home page$/ do
  title = "#{@distributor.country} Orders"
  Then %{I should see "#{title}"}
end
