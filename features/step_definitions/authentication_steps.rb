Given /^I have signed in as an administrator$/ do
  administrator = User.make!

  Given %{I am on the administrator sign-in page}
  When  %{I fill in "Email" with "#{administrator.email}"}
  And   %{I fill in "Password" with "#{administrator.password}"}
  And   %{I press "Sign in"}
end

