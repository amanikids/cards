Then /^I should see the following products:$/ do |expected|
  expected.diff! tableish('table#products tbody tr', 'td')
end

Then /^I should see that the order has been shipped$/ do
  Then %{I should see "Shipped less than a minute ago" within ".shipped ##{dom_id(@order)}"}
end

# TODO need to clean up these cart/order steps
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

  # Save it for further assertions
  @previously_expected_order = expected
end

Then /^I see the following address:$/ do |expected|
  expected.diff! tableish('.address div', 'span')
  # Save it for further assertions
  @previously_expected_address = expected
end

Then /^I see that order again$/ do
  Then %{I see the following order:}, @previously_expected_order
end

Then /^I see that address again$/ do
  Then %{I see the following address:}, @previously_expected_address
end

