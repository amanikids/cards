Feature: Administrators set up the site
  As an administrator
  I want to set up the site by myself
  So that we won't need a developer to do it

  Scenario: Setting up PayPal accounts
    Given I have signed in as an administrator
     When I follow "Accounts"
      And I follow "Create a new PayPal account"
      And I fill in the following:
          | Login     | bob.example.com             |
          | Password  | hdfksalhsf                  |
          | Signature | fdshjaklhjakldfsajhfjklhsaf |
      And I press "Create PayPal account"
     Then I should see "PayPal account created"
      And I should see "bob.example.com"

  @wip
  Scenario: Setting up JustGiving accounts

  @wip
  Scenario: Setting up users

  @wip
  Scenario: Setting up stores with PayPal accounts

  @wip
  Scenario: Setting up stores with JustGiving accounts

  @wip
  Scenario: Setting up products

  Scenario: Signing in as a non-administrator
    Given I am a regular user
     When I sign in on the administrator home page
     Then I should see "Please sign in as an administrator."
