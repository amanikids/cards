# Given /^I have signed in as the distributor for "([^"]*)"$/ do |store|
#   distributor = User.make!(:password => 'secret')

#   Given %{I am on the distributor home page}
#   When  %{I fill in "Email" with "#{distributor.email}"}
#   And   %{I fill in "Password" with "secret"}
#   And   %{I press "Sign in"}
# end

Given /^an unshipped order for "([^"]*)"$/ do |store|
  store = Store.find_by_name(name) || Store.make!(:name => store)
  order = Order.make!(:store => store)
end
