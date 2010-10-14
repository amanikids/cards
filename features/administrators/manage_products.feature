Feature: Administrators manage products
  As an administrator
  I want to manage the products on the site by myself
  So that we won't need a developer to do it

  @wip
  Scenario: Creating a product
    Given I have signed in as an administrator
    When I follow "Products"
    And I fill in "Name" with "Poinsettia Card"
    And I fill in "Price" with "10"
    And I press "Save"
    Then I should see the following products:
      | Name            | Price |
      | Poinsettia Card | 10    |
