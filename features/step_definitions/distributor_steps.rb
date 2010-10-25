Given /^I have signed in as the distributor for "([^"]*)"$/ do |name|
  store = Store.find_by_name(name) ||
    Store.make!(:name => name)

  distributor = store.distributor ||
    Distributor.make!(:store => store)

  user = distributor.user
  user.update_attributes(:password => 'secret')

  Given %{I am on the distributor home page}
  When  %{I fill in "Email" with "#{user.email}"}
  And   %{I fill in "Password" with "secret"}
  And   %{I press "Sign in"}
end

Given /^an unshipped order for "([^"]*)"$/ do |name|
  store = Store.find_by_name(name) || Store.make!(:name => name)
  order = Order.make!(:store => store)
end
