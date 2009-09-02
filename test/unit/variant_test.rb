require File.join(File.dirname(__FILE__), '..', 'test_helper')

class VariantTest < ActiveSupport::TestCase
  should_belong_to :product
  should_validate_presence_of :cents, :currency, :product_id

  context 'with a variant of size 10' do
    setup do
      @inventory = Factory.create(:inventory, :promised => 0)
      @distributor = @inventory.distributor
      @variant = Factory.create(:variant, :size => 10, :product => @inventory.product)
    end

    should 'be available if product quantity is greater than or equal to 1 of me' do
      @inventory.update_attribute(:actual, 10)
      assert @variant.available?(@distributor)
    end

    should 'not be available if product quantity is less than 1 of me' do
      @inventory.update_attribute(:actual, 9)
      assert !@variant.available?(@distributor)
    end

    should 'be running_low if product quantity is less than 25 of me' do
      @inventory.update_attribute(:actual, 249)
      assert @variant.running_low?(@distributor)
    end

    should 'not be running_low if product quantity is greater than or equal to 25 of me' do
      @inventory.update_attribute(:actual, 250)
      assert !@variant.running_low?(@distributor)
    end
  end

  context 'a variant for an on_demand Product' do
    setup do
      @variant = Factory.create(:variant)
      assert @variant.product.inventories.empty?, 'PRECONDITION FAILED (We assume the factory gives us a product with no inventories.)'
    end

    should 'be available' do
      assert @variant.available?(:any_distributor)
    end

    should 'not be running low' do
      assert !@variant.running_low?(:any_distributor)
    end
  end

  should 'have name description name is set' do
    variant = Factory.build(:variant, :name => 'NAME')
    assert_equal 'NAME', variant.description
  end

  should 'have n-pack description when name is blank' do
    variant = Factory.build(:variant, :name => '')
    assert_equal "#{variant.size}-pack", variant.description
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
