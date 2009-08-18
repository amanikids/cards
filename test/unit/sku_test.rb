require 'test_helper'

class SkuTest < ActiveSupport::TestCase
  should_belong_to :product
  should_have_many :inventories
  should_have_many :variants

  should 'delegate product_name to product' do
    sku = Sku.new
    sku.stubs(:product).returns(stub(:name => 'PRODUCT_NAME'))
    assert_equal 'PRODUCT_NAME', sku.product_name
  end

  should 'look up inventory from distributor' do
    inventory   = Factory.create(:inventory)
    distributor = inventory.distributor
    sku         = inventory.sku
    assert_equal inventory, sku.inventory(distributor)
  end

  should 'delgate quantity to inventory(distributor).available' do
    sku = Factory.build(:sku)
    sku.stubs(:inventory).with(:distributor).returns(stub(:available => 300))
    assert_equal 300, sku.quantity(:distributor)
  end

  should 'have zero quantity when inventory(distributor) is nil' do
    sku = Factory.build(:sku)
    sku.stubs(:inventory).with(:distributor).returns(nil)
    assert_equal 0, sku.quantity(:distributor)
  end
end
