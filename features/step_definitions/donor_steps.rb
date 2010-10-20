Given /^these products are for sale:$/ do |table|
  table.hashes.each do |attributes|
    Product.make!(attributes)
  end
end

Given /^I will be using PayPal Express Checkout$/ do
  ShamRack.mount(ShamPayPalAPI.new, 'api-3t.sandbox.paypal.com', 443)
  ShamRack.mount(ShamPayPalUI.new,  'www.sandbox.paypal.com', 443)
end

Then /^I see the following order:$/ do |expected|
  expected.diff! tableish('table#order tbody tr', 'td')
end
