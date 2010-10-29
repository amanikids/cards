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

When /^I press "([^"]*)" for a "([^"]*)" of "([^"]*)" cards$/ do |button, packaging, product|
  product   = Product.find_by_name!(product)
  packaging = product.packagings.find_by_name!(packaging)
  When %{I press "#{button}" within "##{dom_id(packaging)}"}
end

When /^I press "([^"]*)" for the order$/ do |button|
  When %{I press "#{button}" within "##{dom_id(@order)}"}
end
