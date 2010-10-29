# Users ---------------------------------------------------------------
Given /^I am an administrator$/ do
  @user = User.make!
end

Given /^I am the distributor for that store$/ do
  @user = @store.distributor
end

Given /^I am a regular user$/ do
  @user = User.make!
end

# Other Entities ------------------------------------------------------
Given /^there is an FOA group with a PayPal account$/ do
  @account = PaypalAccount.make

  ShamPaypal.new.tap do |paypal|
    ShamRack.mount(paypal, 'api-3t.sandbox.paypal.com', 443)
    Capybara.app = Rack::URLMap.new(
      'https://www.sandbox.paypal.com/' => paypal,
      'http://www.example.com/'         => Capybara.app
    )
  end
end

Given /^there is an FOA group with a JustGiving account$/ do
  @account = JustgivingAccount.make
end

Given /^there is a store called "([^"]*)"( that uses that account)?$/ do |name, uses_account|
  attributes = uses_account ? { :account => @account } : {}
  @store = Store.make!(attributes.merge(:name => name))
end

Given /^that store sells "([^"]*)" cards$/ do |name|
  @product = Product.make!(:name => name, :store => @store)
end

Given /^those cards come in these packagings:$/ do |table|
  table.hashes.each do |attributes|
    Packaging.make!(attributes.merge(:product => @product))
  end
end

Given /^there is an unshipped order for that store$/ do
  @order = Order.make!(:cart => Cart.make!(:store => @store))
end

# Shams ---------------------------------------------------------------
When /^my PayPal shipping address is:$/ do |table|
  ShamPaypal.configure do |app|
    app.shipping_address = table.raw
  end
end
