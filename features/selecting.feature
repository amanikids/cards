Feature: Selecting items
  As a donor
  I want to adjust the items in my cart
  So that I can correct mistakes and change my mind

  Background:
    Given there is a store with currency "USD"
      And that store sells "Poinsettia" cards
      And those cards come in these packagings:
          | name    | size | price |
          | 10-pack | 10   |  1000 |
          | 25-pack | 25   |  2500 |
      And plenty of those cards are available
      And I am on the home page for that store

  Scenario: Adding multiple items
    When I want a "10-pack" of "Poinsettia" cards
     And I select 2 of that packaging
     And I press "Add to Cart" for that packaging
    Then I should see the following cart:
         | Poinsettia | 10-pack | 2 | $20.00 |

  Scenario: Adding an item multiple times
    When I want a "10-pack" of "Poinsettia" cards
     And I press "Add to Cart" for that packaging
     And I press "Add to Cart" for that packaging
    Then I should see the following cart:
         | Poinsettia | 10-pack | 2 | $20.00 |

  Scenario: Removing items
     When I press "Add to Cart" for a "10-pack" of "Poinsettia" cards
      And I press "Add to Cart" for a "25-pack" of "Poinsettia" cards
      And I press "Remove" for the 1st item in my cart
     Then I should see the following cart:
          | Poinsettia | 25-pack | 1 | $25.00 |
