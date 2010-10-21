Feature: Donors buy products
  As a donor
  I want to buy some Christmas cards from Amani
  So that I can greet my friends and support Amani

  Scenario: Buying a product
    Given there is a store called "Canada" that uses PayPal
    And these products are for sale:
      | name       | price |
      | Poinsettia | 10    |
    And I am on the home page

    When I follow "Canada"
    And I press "Add to Cart"
    Then I see the following cart:
      | Poinsettia | 1 | 10 |

    When I press "Check out with PayPal"
    Then I see the following order:
      | Poinsettia | 1 | 10 |

    When I press "Confirm your Order"
    Then I see the following order:
      | Poinsettia | 1 | 10 |

    When I go to the home page
    Then I see an empty cart
