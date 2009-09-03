Feature: Admin tasks
  As an admin
  I want to be able to manage on demand shipments
  So that I can print the cards and send the order

  Background:
    Given a new on-demand shipment exists for an order with token d74280
    And I am logged in as an admin

  Scenario: Shipping an order
    When I follow "d7428"
    And I press "I just shipped this order."
    Then my shipment for order d74280 should be shipped

  Scenario: Cancelling an order
    When I follow "d7428"
    And I press "Cancel this order."
    Then order d74280 should be cancelled
