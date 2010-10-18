Given /^these products are for sale:$/ do |table|
  table.hashes.each do |attributes|
    Product.make!(attributes)
  end
end

When /^I make the payment$/ do
  pending # express the regexp above with the code you wish you had
end

Then /^I see the following cart:$/ do |expected|
  expected.diff! tableish('table#cart tbody tr', 'td')
end

Then /^I see the following order:$/ do |expected|
  expected.diff! tableish('table#order tbody tr', 'td')
end

