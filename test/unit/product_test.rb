require File.join(File.dirname(__FILE__), '..', 'test_helper')

class ProductTest < ActiveSupport::TestCase
  should_validate_presence_of :name
  should_have_many :inventories
  should_have_many :variants

  should 'look up inventory from distributor' do
    inventory   = Factory.create(:inventory)
    distributor = inventory.distributor
    product     = inventory.product
    assert_equal inventory, product.inventory(distributor)
  end

  should 'delgate quantity to inventory(distributor).available' do
    product = Factory.build(:product)
    product.stubs(:inventory).with(:distributor).returns(stub(:available => 300))
    assert_equal 300, product.quantity(:distributor)
  end

  should 'have zero quantity when inventory(distributor) is nil' do
    product = Factory.build(:product)
    product.stubs(:inventory).with(:distributor).returns(nil)
    assert_equal 0, product.quantity(:distributor)
  end

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
 
  should 'by default be ordered by position' do
    products = [
      Factory.create(:product, :position => 2),
      Factory.create(:product, :position => 1)
    ]
    assert_equal products.reverse.collect(&:position), Product.all.collect(&:position)
  end
end
