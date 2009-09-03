Given /^I am logged in as an admin$/ do
  user = Factory.create(:user, :password => 'foo')
  visit('/distributors')
  fill_in("Email",    :with => user.email)
  fill_in("Password", :with => 'foo')
  click_button("Log in")
end

Given /^a new on-demand shipment exists for an order with token (.*)$/ do |token|
  batch = Factory.create(:batch, :distributor => nil)
  Factory.create(:item, :batch => batch, :list => Factory.create(:order))
  batch.items(true)
  batch.order.token = token
  batch.order.save!
end
