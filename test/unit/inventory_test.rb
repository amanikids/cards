require 'test_helper'

class InventoryTest < ActiveSupport::TestCase
  should_belong_to :distributor
  should_belong_to :sku

  should 'subtract promised from actual to get available' do
    inventory = Factory.build(:inventory, :promised => 200)
    inventory.stubs(:actual).returns(300)
    assert_equal 100, inventory.available
  end

  should 'subtract shipped from initial to get actual' do
    inventory = Factory.build(:inventory, :initial => 400, :shipped => 200)
    assert_equal 200, inventory.actual
  end
end
