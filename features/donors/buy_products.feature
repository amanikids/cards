Feature: Donors buy products
  As a donor
  I want to buy some Christmas cards from Amani
  So that I can greet my friends and support Amani

  @wip
  Scenario: Buying a product
    Given these products are for sale:
      | name       | price |
      | Poinsettia | 10    |
    And I am on the home page
    When I press "Add to Cart"
    And I see the following cart:
      | Poinsettia | 1 | 10 |
    And I follow "Proceed to Checkout"
    And I press "Make Payment"
    And I make the payment
    Then I see the following order:
      | Poinsettia | 1 | 10 |
