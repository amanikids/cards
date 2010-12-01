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

  Scenario: Activating Stores
    Given there is a not-yet-active store called "United States"
      And I have signed in as an administrator
     When I follow "Stores"
      And I follow "United States"
      And I follow "Edit this Store"
      And I check "Active"
      And I press "Update Store"
     Then I should see "Store updated"
     When I go to the home page
     Then I should see "United States"

  Scenario: Setting up Products
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

  Scenario: Editing Products
    Given there is a store called "United States"
      And that store sells "Poinsettia" cards
      And I have signed in as an administrator
     When I follow "Stores"
      And I follow "United States"
      And I follow "Poinsettia"
      And I follow "Edit this Product"
      And I fill in "Name" with "Poindexter"
      And I press "Update Product"
     Then I should see "Product updated"
      And I should see "Poindexter"

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

  Scenario: Setting up Inventory
    Given there is a store called "United States"
      And that store sells "Poinsettia" cards
      And I have signed in as an administrator
     When I follow "Stores"
      And I follow "United States"
      And I follow "Poinsettia"
      And I follow "Create a new Transfer"
      And I fill in the following:
          | Quantity | 500              |
          | Reason   | Initial printing |
      And I press "Create Transfer"
     Then I should see "Transfer created"
     When I follow "United States"
     Then I should see the following inventory:
          | Poinsettia | 500 |

  Scenario: Signing in as a non-administrator
    Given I am a regular user
     When I sign in on the administrator home page
     Then I should see "Please sign in as an administrator."
