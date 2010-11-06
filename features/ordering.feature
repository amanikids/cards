Feature: Donors order cards
  As a donor
  I want to order some Christmas cards from Amani
  So that I can greet my friends and support Amani

  Scenario: Ordering products (with PayPal)
    Given there is an FOA group with a PayPal account
      And there is a store called "United States" with currency "USD" that uses that account
      And that store sells "Poinsettia" cards
      And those cards come in these packagings:
          | name    | size | price |
          | 10-pack | 10   |  1000 |
          | 25-pack | 25   |  2500 |
      And I am on the home page

     When I follow "United States"
      And I press "Add to Cart" for a "10-pack" of "Poinsettia" cards
     Then I should see the following cart:
          | Poinsettia | 10-pack | 1 | $10.00 |

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
          | Poinsettia | 10-pack | 1 | $10.00 |
      And I should see the following address:
          | Bob Loblaw    |
          | 123 Main St.  |
          | Anytown, NY   |
          | 12345         |
          | United States |

     When I press "Confirm your order"
     Then I should see that order again
      And I should see that address again

     When I go to the home page
      And I follow "United States"
     Then I should see an empty cart

  Scenario: Ordering products (with JustGiving)
    Given there is an FOA group with a JustGiving account
      And there is a store called "United Kingdom" with currency "GBP" that uses that account
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
          | Name           | Bob Loblaw            |
          | Address        | Little Hedge          |
          | address_line_2 | Brighton              |
          | address_line_3 | Southamptonsfordshire |
          | address_line_4 | 42Y X93               |
          | Country        | United Kingdom        |
      And I press "Proceed"
     Then I should see the following order:
          | Poinsettia | 10-pack | 1 | £5.00 |
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
