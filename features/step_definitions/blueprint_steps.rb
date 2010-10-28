# Users ---------------------------------------------------------------
Given /^I am an administrator$/ do
  @user = User.make!(:password => 'secret')
end

# TODO refactor to "I am the distributor for that store"
Given /^I am the distributor for "([^"]*)"$/ do |name|
  Given %{there is a store called "#{name}"}
  @user = @store.distributor
  @user.update_attributes(:password => 'secret')
end

Given /^I am a regular user$/ do
  @user = User.make!(:password => 'secret')
end

# Other Entities ------------------------------------------------------
Given /^there is a store called "([^"]*)"$/ do |name|
  @store = Store.find_by_name(name) || Store.make!(:name => name)
end

Given /^that store uses PayPal$/ do
  ShamPaypal.new.tap do |paypal|
    ShamRack.mount(paypal, 'api-3t.sandbox.paypal.com', 443)
    Capybara.app = Rack::URLMap.new(
      'https://www.sandbox.paypal.com/' => paypal,
      'http://www.example.com/'         => Rails.application
    )
  end
end

Given /^that store sells these products:$/ do |table|
  table.hashes.each do |attributes|
    Product.make!(attributes.merge(:store => @store))
  end
end

# TODO refactor to "an unshipped order for that store"
Given /^an unshipped order for "([^"]*)"$/ do |name|
  Given %{there is a store called "#{name}"}
  @order = Order.make!(:cart => Cart.make!(:store => @store))
end

# Shams ---------------------------------------------------------------
When /^my PayPal shipping address is:$/ do |table|
  ShamPaypal.configure do |app|
    app.shipping_address = table.raw
  end
end
