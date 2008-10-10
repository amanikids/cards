require 'test_helper'

class VariantTest < ActiveSupport::TestCase
  should_belong_to :product

  should 'delegate product_name to product' do
    variant = Variant.new
    variant.stubs(:product).returns(stub(:name => 'foo'))
    assert_equal 'foo', variant.product_name
  end
end