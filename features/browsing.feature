Feature: Donors browse the site
  As a donor
  I want to look around on the site
  So that I can see what's available

  Scenario: There aren't any stores
    When I go to the home page
    Then I should see "Orders are currently closed."

  Scenario: There aren't any open stores
    Given there is a not-yet-active store
     When I go to the home page
     Then I should see "Orders are currently closed."

  Scenario: Closed stores don't show up
    Given there is a not-yet-active store called "Australia"
     When I go to the home page
     Then I should not see "Australia"

  Scenario: There is an open store
    Given there is a store called "Canada"
     When I go to the home page
     Then I should see "Canada"
      And I should not see "Orders are currently closed."
