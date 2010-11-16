# Users ---------------------------------------------------------------
Given /^I am an administrator$/ do
  @user = Administratorship.make!.user
end

Given /^I am the distributor for that store$/ do
  @user = Distributorship.make!(:store => @store).user
end

Given /^I am a regular user$/ do
  @user = User.make!
end

Given /^there is a user with email address "([^"]*)"$/ do |email|
  @user = User.make!(:email => email)
end

# Other Entities ------------------------------------------------------
Given /^there is an FOA group with a PayPal account$/ do
  @account = PaypalAccount.make

  ShamPaypal.new.tap do |paypal|
    ShamRack.mount(paypal, 'api-3t.sandbox.paypal.com', 443)
    Capybara.app = Rack::URLMap.new(
      'https://www.sandbox.paypal.com/' => paypal,
      'http://www.example.com/' => Capybara.app
    )
  end
end

Given /^there is an FOA group with a JustGiving account$/ do
  @account = JustgivingAccount.make

  ShamJustgiving.new.tap do |justgiving|
    ShamRack.mount(justgiving, 'v3.staging.justgiving.com', 80)
    Capybara.app = Rack::URLMap.new(
      'http://v3.staging.justgiving.com/' => justgiving,
      'http://www.example.com/' => Capybara.app
    )
  end
end

# TODO combine these steps with the above.
Given /^there is a PayPal account with login "([^"]*)"$/ do |login|
  @account = PaypalAccount.make!(:login => login)
end

Given /^there is a JustGiving account with charity id "([^"]*)"$/ do |charity_identifier|
  @account = JustgivingAccount.make!(:charity_identifier => charity_identifier)
end

Given /^there is a( not-yet-active)? store(?: called "([^"]*)")?(?: with currency "([^"]*)")?( that uses that account)?$/ do |inactive, name, currency, uses_account|
  attributes = {}
  attributes[:account]  = @account if uses_account
  attributes[:currency] = currency if currency
  attributes[:name]     = name     if name
  attributes[:active]     = inactive ? false : true
  @store = Store.make!(attributes)
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
  @order = Order.make!(:cart => Cart.make!(:unshipped, :store => @store))
end

# Shams ---------------------------------------------------------------
When /^my PayPal account is "([^"]*)"$/ do |email_address|
  ShamPaypal.configure do |app|
    app.email_address = email_address
  end
end

When /^my PayPal shipping address is:$/ do |table|
  ShamPaypal.configure do |app|
    app.shipping_address = table.raw
  end
end
