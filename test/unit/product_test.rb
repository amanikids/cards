require 'test_helper'

class ProductTest < ActiveSupport::TestCase
  should_require_attributes :name
  should_belong_to :image
  should_have_many :skus
  should_have_many :variants, :through => :skus
  should_have_named_scope :ordered, :order => :position

  should 'filter available_variants by distributor' do
    product     = Factory.build(:product)
    available   = returning(stub) { |variant| variant.stubs(:available?).with(:distributor).returns(true) }
    unavailable = returning(stub) { |variant| variant.stubs(:available?).with(:distributor).returns(false) }
    product.stubs(:variants).returns([available, unavailable])

    assert_equal [available], product.available_variants(:distributor)
  end

  should 'be available if there are available variants' do
    product = Factory.build(:product)
    product.stubs(:available_variants).with(:distributor).returns([Factory.build(:variant)])
    assert product.available?(:distributor)
  end

  should 'not be available if there are no available variants' do
    product = Factory.build(:product)
    product.stubs(:available_variants).with(:distributor).returns([])
    assert !product.available?(:distributor)
  end
end
