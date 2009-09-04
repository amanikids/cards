require File.join(File.dirname(__FILE__), '..', 'test_helper')

class InventoryCacheObserverTest < ActiveSupport::TestCase
  subject { InventoryCacheObserver.instance }
  should_observe :order

  context 'order' do
    setup { @order = Factory(:order) }

    context 'after_create' do
      setup { @result = subject.after_create(@order) }
      before_should('update inventory') { @order.distributor.expects(:order_created).with(@order) }
    end

    context 'after_destroy' do
      setup { @result = subject.after_destroy(@order) }
      before_should('update inventory') { @order.distributor.expects(:order_destroyed).with(@order) }
      should('not return false') { assert_not_equal false, @result }
    end
  end

  context 'batch' do
    setup { @batch = Factory(:batch) }

    context 'after_update' do
      setup { @result = subject.after_update(@batch) }

      before_should('not update inventory for on_demand batch') do
        @batch.expects(:on_demand?).returns(true)
      end
    end
  end
end
