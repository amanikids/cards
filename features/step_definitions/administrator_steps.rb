Given /^I have signed in as an administrator$/ do
  administrator = User.make!(:password => 'secret')

  Given %{I am on the administrator home page}
  When  %{I fill in "Email" with "#{administrator.email}"}
  And   %{I fill in "Password" with "secret"}
  And   %{I press "Sign in"}
end

Then /^I should see the following products:$/ do |expected|
  expected.diff! tableish('table#products tbody tr', 'td')
end

