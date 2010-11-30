Then /^I should see the following products:$/ do |expected|
  expected.diff!(actual_products)
end

Then /^I should see the following cart(?: within "([^"]*)")?:$/ do |selector, expected|
  with_scope(selector) { expected.diff!(actual_cart) }
end

Then /^I should see an empty cart$/ do
  cart = actual_cart
  table(cart).diff!([]) unless cart.empty?
end

Then /^I should see the following order:$/ do |expected|
  Then %{I should see the following cart within ".order":}, expected
  @previously_expected_order = expected
end

Then /^I should see that order again$/ do
  Then %{I should see the following order:}, @previously_expected_order
end

Then /^I should see the following address:$/ do |expected|
  expected.diff!(actual_address)
  @previously_expected_address = expected
end

Then /^I should see that address again$/ do
  Then %{I should see the following address:}, @previously_expected_address
end

Then /^I should see that the (\d+)(?:st|nd|rd|th) item in that order has been shipped$/ do |index|
  Then %{I should see "Shipped less than a minute ago" within "##{dom_id(@order)} .item:nth-child(#{index})"}
end

Then /^I should see the following inventory:$/ do |expected|
  expected.diff!(actual_inventory)
end
