Feature: Administrators manage the offerings
  As an administrator
  I want to configure our product offerings
  So that Amani won't need to spend time having a developer do it

  @wip
  Scenario: Creating a product
    Given I have signed in as an administrator
    When I follow "Products"
    And I fill in "Name" with "Poinsettia, 10-pack"
    And I fill in "Price" with "10"
    And I press "Save"
    Then I should see the following products:
      | Name                | Price |
      | Poinsettia, 10-pack | 10    |
