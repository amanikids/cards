require 'test_helper'

class SkuTest < ActiveSupport::TestCase
  should_belong_to :product
  should_have_many :variants

  should 'delegate product_name to product' do
    sku = Sku.new
    sku.stubs(:product).returns(stub(:name => 'PRODUCT_NAME'))
    assert_equal 'PRODUCT_NAME', sku.product_name
  end
end
