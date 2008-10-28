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

  should 'delegate sku to variant' do
    item = Item.new
    item.stubs(:variant).returns(stub(:sku => 'SKU'))
    assert_equal 'SKU', item.sku
  end

  should 'delegate variant_description to variant' do
    item = Item.new
    item.stubs(:variant).returns(stub(:description => 'DESCRIPTION'))
    assert_equal 'DESCRIPTION', item.variant_description
  end

  should 'delegate variant_price to variant, converting currency' do
    item = Factory.build(:item, :list => Factory.build(:list, :distributor => Factory.build(:distributor, :currency => 'GBP')))
    assert_equal item.variant.price.exchange_to('GBP'), item.variant_price
    assert_equal 'GBP', item.variant_price.currency, 'this is here because exchanged currencies compare as =='
  end

  should 'delegate variant_size to variant' do
    item = Item.new
    item.stubs(:variant).returns(stub(:size => 'SIZE'))
    assert_equal 'SIZE', item.variant_size
  end

  should 'multiply quantity and variant_size to get sku_count' do
    item = Item.new
    item.stubs(:quantity).returns(3)
    item.stubs(:variant_size).returns(7)
    assert_equal 21, item.sku_count
  end

  context 'total' do
    setup do
      @item = Factory.build(:item, :list => Factory.build(:list))
      @item.stubs(:variant).returns(stub(:price => Money.new(5)))
    end

    should 'be the product of the quantity and the variant price' do
      @item.quantity = 2
      assert_equal Money.new(10), @item.total
    end

    should 'exchange the total to the given currency' do
      @item.list.distributor.currency = 'GBP'
      @item.quantity = 2
      assert_equal Money.new(10).exchange_to('GBP'), @item.total
    end

    should 'be as though the quantity were 1 when the quantity is not a number' do
      @item.quantity = 'not a number'
      @item.valid?
      assert_equal Money.new(5), @item.total
    end

    should 'be as though the quantity were 1 when the quantity is negative' do
      @item.quantity = -2
      @item.valid?
      assert_equal Money.new(5), @item.total
    end
  end
end
