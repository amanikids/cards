require 'test_helper'

class ItemTest < ActiveSupport::TestCase
  should_belong_to :order, :variant
  should_require_attributes :order_id, :variant_id

  should 'delegate product_name to variant' do
    item = Item.new
    item.stubs(:variant).returns(stub(:product_name => 'foo'))
    assert_equal 'foo', item.product_name
  end

  should 'delegate total to variant price' do
    item = Item.new
    item.stubs(:variant).returns(stub(:price => Money.new(5)))
    assert_equal Money.new(5), item.total
  end
end
