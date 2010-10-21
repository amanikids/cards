Given /^these products are for sale:$/ do |table|
  table.hashes.each do |attributes|
    Product.make!(attributes)
  end
end

Given /^I will be using PayPal Express Checkout$/ do
  paypal = ShamPayPal.new

  ShamRack.mount(paypal, 'api-3t.sandbox.paypal.com', 443)

  Capybara.app = Rack::URLMap.new(
    'https://www.sandbox.paypal.com/' => paypal,
    'http://www.example.com/'         => Rails.application
  )
end

Then /^I see an empty cart$/ do
  tableish('table.cart tbody tr', 'td').should be_empty
end

Then /^I see the following cart:$/ do |expected|
  expected.diff! tableish('table.cart tbody tr', 'td')
end

Then /^I see the following order:$/ do |expected|
  Then %{I see the following cart:}, expected
end
