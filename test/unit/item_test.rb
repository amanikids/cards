require 'test_helper'

class ItemTest < ActiveSupport::TestCase
  should_belong_to :variant
  should_require_attributes :variant_id

  should_only_allow_numeric_values_for :quantity
  should_not_allow_values_for :quantity, -1, 0, :message => /greater than/
  should_not_allow_values_for :quantity, 3.14, :message =>  /not a number/

  should 'delegate download to variant' do
    item = Item.new
    item.stubs(:variant).returns(stub(:download => 'DOWNLOAD'))
    assert_equal 'DOWNLOAD', item.download
  end

  should 'delegate product_name to variant' do
    item = Item.new
    item.stubs(:variant).returns(stub(:product_name => 'PRODUCT_NAME'))
    assert_equal 'PRODUCT_NAME', item.product_name
  end

  context 'total' do
    should 'be the product of the quantity and the variant price' do
      item = Item.new(:quantity => 2)
      item.stubs(:variant).returns(stub(:price => Money.new(5)))
      assert_equal Money.new(10), item.total
    end

    should 'be as though the quantity were 1 when the quantity is not a number' do
      item = Item.new(:quantity => 'not a number'); item.valid?
      item.stubs(:variant).returns(stub(:price => Money.new(5)))
      assert_equal Money.new(5), item.total
    end

    should 'be as though the quantity were 1 when the quantity is negative' do
      item = Item.new(:quantity => -2); item.valid?
      item.stubs(:variant).returns(stub(:price => Money.new(5)))
      assert_equal Money.new(5), item.total
    end
  end
end
