Feature: Distributors ship products
  As a distributor
  I want to see what unshipped orders I have
  So that I can ship them

  @wip
  Scenario: Shipping an order
    Given an unshipped order for "Canada"
    And I have signed in as the distributor for "Canada"
    When I press "Ship this Order" for the order
    Then I should see that the order has been shipped
