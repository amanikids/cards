Feature: Donors order cards
  As a donor
  I want to order some Christmas cards from Amani
  So that I can greet my friends and support Amani

  Scenario: Ordering products (with PayPal)
    Given there is an FOA group with a PayPal account
      And there is a store called "Canada" that uses that account
      And that store sells "Poinsettia" cards
      And those cards come in these packagings:
          | name    | size | price |
          | 10-pack | 10   |  1000 |
          | 25-pack | 25   |  2500 |
      And I am on the home page

     When I follow "Canada"
      And I press "Add to Cart" for a "10-pack" of "Poinsettia" cards
     Then I should see the following cart:
          | Poinsettia | 10-pack | 1 | 1000 |

     When my PayPal shipping address is:
          | Name            | Bob Loblaw    |
          | Street1         | 123 Main St.  |
          | Street2         |               |
          | CityName        | Anytown       |
          | StateOrProvince | NY            |
          | Country         | United States |
          | PostalCode      | 12345         |
      And I press "Check out with PayPal"
     Then I should see the following order:
          | Poinsettia | 10-pack | 1 | 1000 |
      And I should see the following address:
          | Bob Loblaw    |
          | 123 Main St.  |
          | Anytown, NY   |
          | 12345         |
          | United States |

     When I press "Confirm your Order"
     Then I should see that order again
      And I should see that address again

     When I go to the home page
      And I follow "Canada"
     Then I should see an empty cart

  Scenario: Ordering products (with JustGiving)
    Given there is an FOA group with a JustGiving account
      And there is a store called "United Kingdom" that uses that account
      And that store sells "Poinsettia" cards
      And those cards come in these packagings:
          | name    | size | price |
          | 10-pack | 10   |   500 |
          | 25-pack | 25   |  1250 |
      And I am on the home page

     When I follow "United Kingdom"
      And I press "Add to Cart" for a "10-pack" of "Poinsettia" cards
      And I press "Check out"
      And I fill in the following:
          | Name    | Bob Loblaw            |
          | Line 1  | Little Hedge          |
          | Line 2  | Brighton              |
          | Line 3  | Southamptonsfordshire |
          | Line 4  | 42Y X93               |
          | Country | United Kingdom        |
      And I press "Proceed"
     Then I should see the following order:
          | Poinsettia | 10-pack | 1 | 500 |
      And I should see the following address:
          | Bob Loblaw            |
          | Little Hedge          |
          | Brighton              |
          | Southamptonsfordshire |
          | 42Y X93               |
          | United Kingdom        |

     When I press "Donate with JustGiving"
     Then I should see that order again
      And I should see that address again

     When I go to the home page
      And I follow "United Kingdom"
     Then I should see an empty cart
