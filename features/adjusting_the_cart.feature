Feature: Adjusting the cart
  As a donor
  I want to adjust the items in my cart
  So that I can correct mistakes and change my mind

  Scenario: Removing items
    Given there is a store with currency "USD"
      And that store sells "Poinsettia" cards
      And those cards come in these packagings:
          | name    | size | price |
          | 10-pack | 10   |  1000 |
          | 25-pack | 25   |  2500 |
      And I am on the home page for that store
     When I press "Add to Cart" for a "10-pack" of "Poinsettia" cards
      And I press "Add to Cart" for a "25-pack" of "Poinsettia" cards
      And I press "Remove" for the 1st item in my cart
     Then I should see the following cart:
          | Poinsettia | 25-pack | 1 | $25.00 |
