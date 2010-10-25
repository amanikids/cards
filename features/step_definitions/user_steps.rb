Given /^I am a regular user$/ do
  @user = User.make!(:password => 'secret')
end

Given /^I (?:have )?sign(?:ed)? in on (.+)$/ do |page_name|
  Given %{I am on #{page_name}}
  And   %{I fill in "Email" with "#{@user.email}"}
  And   %{I fill in "Password" with "secret"}
  And   %{I press "Sign in"}
end
