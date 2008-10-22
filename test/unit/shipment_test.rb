require 'test_helper'

class ShipmentTest < ActiveSupport::TestCase
  should_belong_to :order
  should_belong_to :shipper
end
