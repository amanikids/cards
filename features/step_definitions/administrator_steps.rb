Given /^I have signed in as an administrator$/ do
  Given %{I am an administrator}
  And   %{I have signed in on the administrator home page}
end

Given /^I am an administrator$/ do
  @user = User.make!(:password => 'secret')
end

Then /^I should see the following products:$/ do |expected|
  expected.diff! tableish('table#products tbody tr', 'td')
end

