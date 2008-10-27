require 'test_helper'

class VariantTest < ActiveSupport::TestCase
  should_belong_to :sku
  should_belong_to :download
  should_require_attributes :cents, :currency, :sku_id

  should 'delegate description to sku_name when size is 1' do
    variant = Variant.new(:size => 1)
    variant.stubs(:sku_name).returns('SKU_NAME')
    assert_equal 'SKU_NAME', variant.description
  end

  should 'delegate description to size and sku_name when size is greater than 1' do
    variant = Variant.new(:size => 2)
    variant.stubs(:sku_name).returns('SKU_NAME')
    assert_equal '2-pack SKU_NAME', variant.description
  end

  should 'delegate product_name to sku' do
    variant = Variant.new
    variant.stubs(:sku).returns(stub(:product_name => 'PRODUCT_NAME'))
    assert_equal 'PRODUCT_NAME', variant.product_name
  end

  should 'delegate sku_name to sku' do
    variant = Variant.new
    variant.stubs(:sku).returns(stub(:name => 'SKU_NAME'))
    assert_equal 'SKU_NAME', variant.sku_name
  end
end
