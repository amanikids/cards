Feature: Distributor tasks
  As a distributor
  I want to be able to manage shipments that belong to me
  So that amani and the customer know which orders have been sent


  Background:
    Given a new shipment exists for an order with token d74280
    And I am logged in as a distributor for order d74280

  Scenario: Shipping an order
    When I follow "d7428"
    And I press "I just shipped this order."
    Then my shipment for order d74280 should be shipped

  Scenario: Cancelling a shipment
    When I follow "d7428"
    And I press "I just shipped this order."
    And I press "Oops! Cancel this Shipment!"
    Then my shipment for order d74280 should not be shipped

  Scenario: Cancelling an order
    When I follow "d7428"
    And I press "Cancel this order."
    Then order d74280 should be cancelled

  Scenario: Receiving a check for a donation
    Given the donor has indicated they made a donation for order "d74280"
    When I follow "d7428"
    And I press "I just received this donation."
    Then the received at date for order "d74280" should be today
    And I should see "We received the donation for this order"

  Scenario: Trying to view another Distributor's order
    Given a new shipment exists for an order with token 1984c
    When I visit the first batch for order "1984c"
    Then I should be redirected to my home page
