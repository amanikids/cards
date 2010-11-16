Feature: Distributors ship products
  As a distributor
  I want to see what unshipped orders I have
  So that I can ship them

  Scenario: Shipping an order
    Given there is a store called "Canada"
      And there is an unshipped order for that store
      And I have signed in as the distributor for that store
     When I follow "Canada"
      And I press "Ship this Order" for the order
      And I follow "Shipped orders"
     Then I should see that the order has been shipped

  Scenario: Signing in as a non-distributor
    Given I am a regular user
     When I sign in on the distributor home page
     Then I should see "Please sign in as a distributor."
