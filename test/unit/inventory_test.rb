require 'test_helper'

class InventoryTest < ActiveSupport::TestCase
  should_belong_to :distributor
  should_belong_to :sku
end
