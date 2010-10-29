Feature: Donors buy products
  As a donor
  I want to buy some Christmas cards from Amani
  So that I can greet my friends and support Amani

  Scenario: Buying a product
    Given there is a store called "Canada"
    And that store uses PayPal
    And that store sells "Poinsettia" cards
    And those cards come in these packagings:
      | name    | size | price |
      | 10-pack | 10   | 1000  |
      | 25-pack | 25   | 2500  |
    And I am on the home page

    When I follow "Canada"
    And I press "Add to Cart" for a "10-pack" of "Poinsettia" cards
    Then I see the following cart:
      | Poinsettia | 10-pack | 1 | 1000 |

    When my PayPal shipping address is:
      | Name            | Bob Loblaw    |
      | Street1         | 123 Main St.  |
      | Street2         |               |
      | CityName        | Anytown       |
      | StateOrProvince | NY            |
      | Country         | United States |
      | PostalCode      | 12345         |
    And I press "Check out with PayPal"
    Then I see the following order:
      | Poinsettia | 10-pack | 1 | 1000 |
    And I see the following address:
      | Bob Loblaw        |
      | 123 Main St.      |
      | Anytown, NY       |
      | 12345             |
      | United States     |

    When I press "Confirm your Order"
    Then I see the following order:
      | Poinsettia | 10-pack | 1 | 1000 |

    When I go to the home page
    And I follow "Canada"
    Then I see an empty cart
