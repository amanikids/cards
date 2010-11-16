Given /^I have signed in as an administrator$/ do
  Given %{I am an administrator}
  And   %{I have signed in on the administrator home page}
end

Given /^I have signed in as the distributor for that store$/ do
  Given %{I am the distributor for that store}
  And   %{I have signed in on the distributor home page}
end

Given /^I (?:have )?sign(?:ed)? in on (.+)$/ do |page_name|
  Given %{I am on #{page_name}}
  And   %{I fill in "Email" with "#{@user.email}"}
  And   %{I fill in "Password" with "secret"}
  And   %{I press "Sign in"}
end

When /^I want a "([^"]*)" of "([^"]*)" cards$/ do |packaging, product|
  @product   = Product.find_by_name!(product)
  @packaging = @product.packagings.find_by_name!(packaging)
end

When /^I select (\d+) of that packaging$/ do |value|
  When %{I select "#{value}" from "item_quantity" within "##{dom_id(@packaging)}"}
end

When /^I press "([^"]*)" for that packaging$/ do |button|
  When %{I press "#{button}" within "##{dom_id(@packaging)}"}
end

# TODO possibly inline this step?
When /^I press "([^"]*)" for a "([^"]*)" of "([^"]*)" cards$/ do |button, packaging, product|
  When %{I want a "#{packaging}" of "#{product}" cards}
  When %{I press "#{button}" for that packaging}
end

When /^I press "([^"]*)" for the (\d+)(?:st|nd|rd|th) item in my cart$/ do |button, index|
  When %{I press "#{button}" within ".cart .item:nth-child(#{index})"}
end

When /^I check the (\d+)(?:st|nd|rd|th) item in that order$/ do |index|
  When %{I check "order_items_attributes_#{index.to_i.pred}_shipped_at" within "##{dom_id(@order)} .item:nth-child(#{index})"}
end

When /^I press "([^"]*)" for the order$/ do |button|
  When %{I press "#{button}" within "##{dom_id(@order)}"}
end
