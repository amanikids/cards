require 'test_helper'

class InventoryTest < ActiveSupport::TestCase
  should_belong_to :distributor
  should_belong_to :sku

  should_protect_attributes :initial, :promised, :shipped

  should 'subtract promised from actual to get available' do
    inventory = Factory.build(:inventory, :promised => 200)
    inventory.stubs(:actual).returns(300)
    assert_equal 100, inventory.available
  end

  should 'subtract shipped from initial to get actual' do
    inventory = Factory.build(:inventory, :initial => 400, :shipped => 200)
    assert_equal 200, inventory.actual
  end

  context 'given an existing Inventory item' do
    setup { @inventory = Factory.create(:inventory, :promised => 100, :shipped => 100) }

    context 'clear_cache' do
      setup { @inventory.clear_cache }
      should_change '@inventory.promised', :to => 0
      should_change '@inventory.shipped',  :to => 0
      should_not_change '@inventory.reload.promised'
      should_not_change '@inventory.reload.shipped'
    end

    context 'promised_item' do
      setup { @inventory.promised_item(stub(:sku_count => 42)) }
      should_change '@inventory.promised', :by => 42
      should_not_change '@inventory.shipped'
      should_not_change '@inventory.reload.promised'
      should_not_change '@inventory.reload.shipped'
    end

    context 'shipped_item' do
      setup { @inventory.shipped_item(stub(:sku_count => 42)) }
      should_not_change '@inventory.promised'
      should_change '@inventory.shipped', :by => 42
      should_not_change '@inventory.reload.promised'
      should_not_change '@inventory.reload.shipped'
    end
  end
end
