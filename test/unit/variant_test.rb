require 'test_helper'

class VariantTest < ActiveSupport::TestCase
  should_belong_to :product
  should_belong_to :download
  should_require_attributes :name, :cents, :currency, :product_id

  should 'delegate description to name when size is 1' do
    variant = Variant.new(:name => 'NAME', :size => 1)
    assert_equal 'NAME', variant.description
  end

  should 'delegate description to size and name when size is greater than 1' do
    variant = Variant.new(:name => 'NAME', :size => 2)
    assert_equal '2-pack NAME', variant.description
  end

  should 'delegate product_name to product' do
    variant = Variant.new
    variant.stubs(:product).returns(stub(:name => 'foo'))
    assert_equal 'foo', variant.product_name
  end
end
