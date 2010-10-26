Given /^I have signed in as the distributor for "([^"]*)"$/ do |name|
  Given %{I am the distributor for "#{name}"}
  And   %{I have signed in on the distributor home page}
end

Given /^I am the distributor for "([^"]*)"$/ do |name|
  store = Store.find_by_name(name) ||
    Store.make!(:name => name)

  @user = store.distributor
  @user.update_attributes(:password => 'secret')
end

Given /^an unshipped order for "([^"]*)"$/ do |name|
  store  = Store.find_by_name(name) || Store.make!(:name => name)
  @order = Order.make!(:store => store)
end

When /^I press "([^"]*)" for the order$/ do |button|
  When %{I press "#{button}" within "##{dom_id(@order)}"}
end
