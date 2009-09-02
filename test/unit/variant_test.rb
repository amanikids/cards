require File.join(File.dirname(__FILE__), '..', 'test_helper')

class VariantTest < ActiveSupport::TestCase
  should_belong_to :product
  should_validate_presence_of :cents, :currency, :product_id

  context 'with a variant of size 10' do
    setup { @variant = Factory.build(:variant, :size => 10) }

    should 'be available if product quantity is greater than or equal to 1 of me' do
      @variant.product.stubs(:quantity).with(:distributor).returns(10)
      assert @variant.available?(:distributor)
    end

    should 'not be available if product quantity is less than 1 of me' do
      @variant.product.stubs(:quantity).with(:distributor).returns(9)
      assert !@variant.available?(:distributor)
    end

    should 'be running_low if product quantity is less than 25 of me' do
      @variant.product.stubs(:quantity).with(:distributor).returns(249)
      assert @variant.running_low?(:distributor)
    end

    should 'not be running_low if product quantity is greater than or equal to 25 of me' do
      @variant.product.stubs(:quantity).with(:distributor).returns(250)
      assert !@variant.running_low?(:distributor)
    end
  end

  should 'have blank description when size is 1' do
    variant = Variant.new(:size => 1)
    assert_equal '', variant.description
  end

  should 'have n-pack description when size is greater than 1' do
    variant = Variant.new(:size => 2)
    assert_equal '2-pack', variant.description
  end

  should 'delegate product_name to product' do
    variant = Variant.new
    variant.stubs(:product).returns(stub(:name => 'PRODUCT_NAME'))
    assert_equal 'PRODUCT_NAME', variant.product_name
  end

  should 'by default be ordered by position' do
    variants = [
      Factory.create(:variant, :position => 2),
      Factory.create(:variant, :position => 1)
    ]
    assert_equal variants.reverse.collect(&:position), Variant.all.collect(&:position)
  end
end
