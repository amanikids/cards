Feature: Administrators manage products
  As an administrator
  I want to manage the products on the site by myself
  So that we won't need a developer to do it

  @wip
  Scenario: Creating a product
    Given there is a store called "Canada"
    And I have signed in as an administrator
    When I follow "Stores"
    And I follow "Canada"
    And I follow "Create a new Product"
    And I fill in "Name" with "Poinsettia Card"
    And I fill in "Price" with "10"
    And I press "Create Product"
    Then I should see the following products:
      | Poinsettia Card | 10 |

  @wip
  Scenario: Signing in as a non-administrator
    Given I am a regular user
    When I sign in on the administrator home page
    Then I should see "Please sign in as an administrator."
