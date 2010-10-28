Given /^I have signed in as an administrator$/ do
  Given %{I am an administrator}
  And   %{I have signed in on the administrator home page}
end

Given /^I have signed in as the distributor for "([^"]*)"$/ do |name|
  Given %{I am the distributor for "#{name}"}
  And   %{I have signed in on the distributor home page}
end

Given /^I (?:have )?sign(?:ed)? in on (.+)$/ do |page_name|
  Given %{I am on #{page_name}}
  And   %{I fill in "Email" with "#{@user.email}"}
  And   %{I fill in "Password" with "secret"}
  And   %{I press "Sign in"}
end

When /^I press "([^"]*)" for the order$/ do |button|
  When %{I press "#{button}" within "##{dom_id(@order)}"}
end
