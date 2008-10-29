require 'test_helper'

class VariantTest < ActiveSupport::TestCase
  should_belong_to :sku
  should_belong_to :download
  should_require_attributes :cents, :currency, :sku_id

  context 'with a downloadable variant' do
    setup { @variant = Factory.build(:variant_with_download) }

    should 'always be available' do
      assert @variant.available?(:distributor)
    end

    should 'never be running_low' do
      assert !@variant.running_low?(:distributor)
    end
  end

  # TODO consult Joe for the available? and running_low? thresholds
  context 'with a variant of size 10' do
    setup { @variant = Factory.build(:variant, :size => 10) }

    should 'be available if sku quantity is greater than or equal to 1 of me' do
      @variant.sku.stubs(:quantity).with(:distributor).returns(10)
      assert @variant.available?(:distributor)
    end

    should 'not be available if sku quantity is less than 1 of me' do
      @variant.sku.stubs(:quantity).with(:distributor).returns(9)
      assert !@variant.available?(:distributor)
    end

    should 'be running_low if sku quantity is less than 6 of me' do
      @variant.sku.stubs(:quantity).with(:distributor).returns(59)
      assert @variant.running_low?(:distributor)
    end

    should 'not be running_low if sku quantity is greater than or equal to 6 of me' do
      @variant.sku.stubs(:quantity).with(:distributor).returns(60)
      assert !@variant.running_low?(:distributor)
    end
  end

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
