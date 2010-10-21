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

Then /^I see the following order:$/ do |expected|
  expected.diff! tableish('table.order tbody tr', 'td')
end
