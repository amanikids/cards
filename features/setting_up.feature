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

  Scenario: Setting up JustGiving accounts
    Given I have signed in as an administrator
     When I follow "Accounts"
      And I follow "Create a new JustGiving account"
      And I fill in the following:
          | Charity ID | 12345 |
      And I press "Create JustGiving account"
     Then I should see "JustGiving account created"
      And I should see "12345"

  Scenario: Setting up users
    Given I have signed in as an administrator
     When I follow "Users"
      And I follow "Create a new User"
      And I fill in the following:
          | Email address | bob@example.com |
      And I press "Create User"
     Then I should see "User created"
      And I should see "bob@example.com"

  @wip
  Scenario: Setting up administrators

  Scenario: Setting up stores with PayPal accounts
    Given there is a PayPal account with login "bob.example.com"
      And there is a user with email address "bob@example.com"
      And I have signed in as an administrator
     When I follow "Stores"
      And I follow "Create a new Store"
      And I fill in the following:
          | Name        | Canada                      |
          | Currency    | CAD                         |
          | Description | Support the Amani kids, eh? |
          | Slug        | ca                          |
      And I select "bob.example.com" from "Account"
      And I select "bob@example.com" from "Distributor"
      And I press "Create Store"
     Then I should see "Store created"
      And I should see "Canada"

  Scenario: Setting up stores with JustGiving accounts
    Given there is a JustGiving account with charity id "12345"
      And there is a user with email address "bob@example.com"
      And I have signed in as an administrator
     When I follow "Stores"
      And I follow "Create a new Store"
      And I fill in the following:
          | Name        | United Kingdom                    |
          | Currency    | GBP                               |
          | Description | Support the Amani kids, governor? |
          | Slug        | uk                                |
      And I select "12345" from "Account"
      And I select "bob@example.com" from "Distributor"
      And I press "Create Store"
     Then I should see "Store created"
      And I should see "United Kingdom"

  @wip
  Scenario: Activating Stores

  Scenario: Setting up products
    Given there is a store called "United States"
      And I have signed in as an administrator
     When I follow "Stores"
      And I follow "United States"
      And I follow "Create a new Product"
      And I fill in the following:
          | Name        | Poinsettia   |
          | Description | Just lovely! |
      And I select "2010/poinsettia.jpg" from "Image"
      And I press "Create Product"
     Then I should see "Product created"
      And I should see "Poinsettia"

  Scenario: Setting up Packagings
    Given there is a store called "United States"
      And that store sells "Poinsettia" cards
      And I have signed in as an administrator
     When I follow "Stores"
      And I follow "United States"
      And I follow "Poinsettia"
      And I follow "Create a new Packaging"
      And I fill in the following:
          | Name  | 10-pack |
          | Size  | 10      |
          | Price | 1000    |
      And I press "Create Packaging"
     Then I should see "Packaging created"
      And I should see "10-pack"

  Scenario: Signing in as a non-administrator
    Given I am a regular user
     When I sign in on the administrator home page
     Then I should see "Please sign in as an administrator."
