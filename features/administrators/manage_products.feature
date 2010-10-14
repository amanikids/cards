Feature: Administrators manage products
  As an administrator
  I want to manage the products on the site by myself
  So that we won't need a developer to do it

  Scenario: Creating a product
    Given I have signed in as an administrator
    When I follow "Products"
    And I follow "Create a new Product"
    And I fill in "Name" with "Poinsettia Card"
    And I fill in "Price" with "10"
    And I press "Create Product"
    Then I should see the following products:
      | Poinsettia Card | 10 |
