# Users ---------------------------------------------------------------
Given /^I am an administrator$/ do
  @user = User.make!(:password => 'secret')
end

Given /^I am the distributor for "([^"]*)"$/ do |name|
  store = Store.find_by_name(name) ||
    Store.make!(:name => name)

  @user = store.distributor
  @user.update_attributes(:password => 'secret')
end

Given /^I am a regular user$/ do
  @user = User.make!(:password => 'secret')
end

# Other Entities ------------------------------------------------------
Given /^there is a store called "([^"]*)" that uses PayPal$/ do |name|
  Store.make!(:name => name)

  ShamPaypal.new.tap do |paypal|
    ShamRack.mount(paypal, 'api-3t.sandbox.paypal.com', 443)
    Capybara.app = Rack::URLMap.new(
      'https://www.sandbox.paypal.com/' => paypal,
      'http://www.example.com/'         => Rails.application
    )
  end
end

Given /^these products are for sale:$/ do |table|
  table.hashes.each do |attributes|
    Product.make!(attributes)
  end
end

Given /^an unshipped order for "([^"]*)"$/ do |name|
  store  = Store.find_by_name(name) || Store.make!(:name => name)
  @order = Order.make!(:cart => Cart.make!(:store => store))
end

# Shams ---------------------------------------------------------------
When /^my PayPal shipping address is:$/ do |table|
  ShamPaypal.configure do |app|
    app.shipping_address = table.raw
  end
end
