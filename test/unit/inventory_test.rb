require 'test_helper'

class InventoryTest < ActiveSupport::TestCase
  should_belong_to :distributor
  should_belong_to :sku

  context 'an inventory' do
    setup { @inventory = Factory.build(:inventory, :initial => 400, :promised => 200, :shipped => 100) }

    should 'subtract promised from initial to get available' do
      assert_equal 200, @inventory.available
    end

    should 'subtract shipped from initial to get actual' do
      assert_equal 300, @inventory.actual
    end
  end
end
