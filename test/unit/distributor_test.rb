require 'test_helper'

class DistributorTest < ActiveSupport::TestCase
  should_have_many :carts
  should_have_many :distributor_donation_methods
  should_have_many :donation_methods, :through => :distributor_donation_methods
  should_have_many :inventories
  should_have_many :orders

  should_require_attributes :country_code, :currency

  should 'delegate to_param to country_code' do
    distributor = Factory.build(:distributor, :country_code => 'COUNTRY_CODE')
    assert_equal 'COUNTRY_CODE', distributor.to_param
  end

  context 'with an existing Distributor' do
    setup { @distributor = Factory.create(:distributor) }

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
  end

  context 'with any old Distributor' do
    setup { @distributor = Factory.build(:distributor) }

    should 'delegate orders_unshipped to orders.unshipped' do
      @distributor.stubs(:orders).returns(stub(:unshipped => 'UNSHIPPED'))
      assert_equal 'UNSHIPPED', @distributor.orders_unshipped
    end

    should 'delegate orders_shipped to orders.shipped' do
      @distributor.stubs(:orders).returns(stub(:shipped => 'SHIPPED'))
      assert_equal 'SHIPPED', @distributor.orders_shipped
    end

    should 'clear_inventory_cache' do
      @distributor.stubs(:inventories).returns [mock(:clear_cache), mock(:clear_cache)]
      @distributor.send(:clear_inventory_cache)
    end

    should 'count_orders_unshipped' do
      inventory = returning(stub(:sku => 'SKU')) { |stub| stub.expects(:promised_item).with('ITEM') }
      order     = returning(stub) { |stub| stub.expects(:items_for).with('SKU').returns ['ITEM'] }

      @distributor.stubs(:inventories).returns [inventory]
      @distributor.stubs(:orders_unshipped).returns [order]
      @distributor.send(:count_orders_unshipped)
    end

    should 'count_orders_shipped' do
      inventory = returning(stub(:sku => 'SKU')) { |stub| stub.expects(:shipped_item).with('ITEM') }
      order     = returning(stub) { |stub| stub.expects(:items_for).with('SKU').returns ['ITEM'] }

      @distributor.stubs(:inventories).returns [inventory]
      @distributor.stubs(:orders_shipped).returns [order]
      @distributor.send(:count_orders_shipped)
    end

    should 'save_inventory' do
      @distributor.stubs(:inventories).returns [mock(:save), mock(:save)]
      @distributor.send(:save_inventory)
    end

    should 'reset_inventory_cache' do
      @distributor.expects(:clear_inventory_cache)
      @distributor.expects(:count_orders_unshipped)
      @distributor.expects(:count_orders_shipped)
      @distributor.expects(:save_inventory)
      @distributor.reset_inventory_cache
    end
  end
end