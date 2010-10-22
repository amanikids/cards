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

# FIXME need to clean up these cart/order steps
Then /^I see an empty cart$/ do
  cart = tableish('table.cart tbody tr', 'td')
  table(cart).diff!([]) unless cart.empty?
end

Then /^I see the following cart:$/ do |expected|
  expected.diff! tableish('table.cart tbody tr', 'td')
end

Then /^I see the following order:$/ do |expected|
  with_scope('.order') do
    Then %{I see the following cart:}, expected
  end
end
