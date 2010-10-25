Feature: Distributors ship products
  As a distributor
  I want to see what unshipped orders I have
  So that I can ship them

  @wip
  Scenario: Shipping an order
    Given an unshipped order for "Canada"
    When I have signed in as the distributor for "Canada"
    Then I should see the order
