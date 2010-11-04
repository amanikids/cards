Feature: Administrators set up the site
  As an administrator
  I want to set up the site by myself
  So that we won't need a developer to do it

  Scenario: Signing in as a non-administrator
    Given I am a regular user
     When I sign in on the administrator home page
     Then I should see "Please sign in as an administrator."
