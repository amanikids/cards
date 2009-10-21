require File.join(File.dirname(__FILE__), '..', 'test_helper')

class ItemTest < ActiveSupport::TestCase
  should_belong_to :batch
  should_belong_to :variant
  should_validate_presence_of :variant_id

  should_validate_numericality_of :quantity
  should_not_allow_values_for :quantity, -1, 0, :message => /greater than/
  should_not_allow_values_for :quantity, 3.14, :message =>  /not a number/

  context 'delgation' do
    setup do
      @item = Factory.build(:item)
    end

    should 'delegate product_name to variant' do
      assert_equal @item.variant.product_name, @item.product_name
    end

    should 'delegate product_short_name to variant' do
      assert_equal @item.variant.product_short_name, @item.product_short_name
    end

    should 'delegate product to variant' do
      assert_equal @item.variant.product, @item.product
    end

    should 'delegate variant_description to variant' do
      assert_equal @item.variant.description, @item.variant_description
    end

    should 'delegate variant_price to variant, converting currency' do
      item = Factory.build(:item, :list => Factory.build(:list, :distributor => Factory.build(:distributor, :currency => 'GBP')))
      assert_equal item.variant.price.exchange_to('GBP'), item.variant_price
      assert_equal 'GBP', item.variant_price.currency, 'this is here because exchanged currencies compare as =='
    end

    should 'delegate variant_size to variant' do
      assert_equal @item.variant.size, @item.variant_size
    end
  end

  should 'multiply quantity and variant_size to get product_count' do
    item = Item.new
    item.stubs(:quantity).returns(3)
    item.stubs(:variant_size).returns(7)
    assert_equal 21, item.product_count
  end

  context '#product_name_and_short_name' do
    should 'return the product name followed by the product short name in parentheses' do
      item = Item.new
      item.stubs(:product_name).returns('PRODUCT NAME')
      item.stubs(:product_short_name).returns('PRODUCT SHORT NAME')
      assert_equal 'PRODUCT NAME (PRODUCT SHORT NAME)', item.product_name_and_short_name
    end

    should 'return the product name when the product short name is blank' do
      item = Item.new
      item.stubs(:product_name).returns('PRODUCT NAME')
      item.stubs(:product_short_name).returns('')
      assert_equal 'PRODUCT NAME', item.product_name_and_short_name
    end
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

  context '#available?' do
    setup do
      physical_card = Factory.create(:product)

      @distributor  = Factory.create(:distributor)
      @inventory    = Factory.create(:inventory, :distributor => @distributor, :product => physical_card)
      @item         = Factory.create(:item, :variant => Factory.create(:variant, :size => 10, :product => physical_card))
    end

    should "be false when the distributor doesn't have enough inventory" do
      @inventory.update_attributes(:actual => @item.product_count - 1)
      @item.available?(@distributor).should == false
    end

    should "be true when the distributor does have enough inventory" do
      @inventory.update_attributes(:actual => @item.product_count)
      @item.available?(@distributor).should == true
    end
  end
end
