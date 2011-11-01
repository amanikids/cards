Feature: Restricting inventory
  As a distributor
  I want donors to not see the items I can't fulfill
  So that I won't have to sort it out with them after the fact

  Background:
    Given there is a store with currency "USD"
      And that store sells "Poinsettia" cards
      And those cards come in these packagings:
          | name    | size | price |
          | 10-pack | 10   |  1000 |
          | 25-pack | 25   |  2500 |

  Scenario: Cards are sold out
    Given 0 of those cards are available
     When I go to the home page for that store
     Then I should not see those cards

  Scenario: Cards are running low
    Given 50 of those cards are available
     When I go to the home page for that store
     Then I should not see those cards

  Scenario: Cards are available
    Given plenty of those cards are available
     When I go to the home page for that store
     Then I should see those cards

  Scenario: On demand cards are always available
    Given those cards are printed on demand
      And 0 of those cards are available
     When I go to the home page for that store
     Then I should see those cards
