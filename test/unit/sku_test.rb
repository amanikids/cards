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

  context 'with an existing inventory item' do
    setup do
      @inventory = Factory.create(:inventory)
      @distributor, @sku = @inventory.distributor, @inventory.sku
    end

    should 'look up quantity from inventory' do
      assert_equal @inventory.quantity, @sku.quantity(@distributor)
    end
  end
end
