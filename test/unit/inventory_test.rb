require File.join(File.dirname(__FILE__), '..', 'test_helper')

class InventoryTest < ActiveSupport::TestCase
  should_belong_to :distributor
  should_belong_to :product

  should_validate_numericality_of :actual
  should_not_allow_values_for :actual, -1, :message => /greater than/
  should_not_allow_values_for :actual, 3.14, :message =>  /not a number/

  context 'an inventory' do
    setup { @inventory = Factory.build(:inventory, :initial => 400, :promised => 200, :shipped => 100) }

    should 'subtract promised from initial to get available' do
      assert_equal 200, @inventory.available
    end

    should 'subtract shipped from initial to get actual' do
      assert_equal 300, @inventory.actual
    end

    should 'adjust inital when setting actual' do
      @inventory.update_attributes('actual' => '250')
      assert_equal 350, @inventory.reload.initial
    end

    should 'delegate product_name to product' do
      assert_equal @inventory.product.name, @inventory.product_name
    end
  end
end
