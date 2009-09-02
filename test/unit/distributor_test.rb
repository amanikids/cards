require File.join(File.dirname(__FILE__), '..', 'test_helper')

class DistributorTest < ActiveSupport::TestCase
  should_have_many :carts
  should_have_many :donation_methods
  should_have_many :inventories
  should_have_many :orders

  should_validate_presence_of :country_code, :currency

  should 'delegate to_param to country_code' do
    distributor = Factory.build(:distributor, :country_code => 'COUNTRY_CODE')
    assert_equal 'COUNTRY_CODE', distributor.to_param
  end

  context 'with an existing Distributor' do
    setup { @distributor = Factory(:distributor) }

    context 'find_by_param' do
      should 'return distributor when find_by_param with to_param' do
        assert_equal @distributor, Distributor.find_by_param(@distributor.to_param)
      end

      should 'raise NotFound with find_by_param with something else' do
        assert_raise(ActiveRecord::RecordNotFound) do
          Distributor.find_by_param('NO DISTRIBUTOR SHOULD HAVE THIS TO_PARAM')
        end
      end
    end

    context 'update inventories' do
      setup { @inventory = Factory(:inventory, :distributor => @distributor) }

      should 'have the inventory' do
        assert_equal [@inventory], @distributor.inventories
      end

      context 'with valid attributes' do
        setup { @result = @distributor.update_inventories(@inventory.id => {'actual' => '200'}) }
        should('return true') { assert @result }
        should_change '@inventory.reload.actual', :to => 200
      end

      context 'with invalid attributes' do
        setup { @result = @distributor.update_inventories(@inventory.id => {'actual' => 'a'}) }
        should('return false') { assert !@result }
        should_not_change '@inventory.reload.actual'
      end
    end
  end

  context '#sold_out?' do
    should 'be true when the distributor has no inventory' do
      distributor = Factory.create(:distributor)
      assert_equal true, distributor.sold_out?
    end

    should 'be true when no variants are in stock for the distributor' do
      distributor = Factory.create(:inventory, :initial => 0).distributor
      assert_equal true, distributor.sold_out?
    end

    should 'be true when stock is left but not enough to fulfill any variants' do
      inventory = Factory.create(:inventory, :initial => 1)
      distributor = inventory.distributor
      Factory.create(:variant, :product => inventory.product, :size => 2)

      assert_equal true, distributor.sold_out?
    end

    should 'be false when at least one variant is in stock for the distributor' do
      inventory = Factory.create(:inventory, :initial => 1)
      distributor = inventory.distributor
      Factory.create(:variant, :product => inventory.product, :size => 1)

      assert_equal false, distributor.sold_out?
    end
  end
 
  should 'by default be ordered by position' do
    expected = [
      Factory.create(:distributor, :position => 2),
      Factory.create(:distributor, :position => 1)
    ].reverse.collect(&:position)
    actual = Distributor.all.collect(&:position)

    assert_equal expected, actual
  end
end
