require 'test_helper'

class NotificationObserverTest < ActiveSupport::TestCase
  should_observe :order, :shipment

  context 'with an existing Order' do
    setup { @order = Factory.create(:order) }

    context 'after_create' do
      setup { observer.after_create(@order) }
      before_should('deliver notification') { Mailer.expects(:deliver_order_created).with(@order) }
    end

    context 'before_update' do
      setup { @result = observer.before_update(@order) }
      before_should('not deliver notification') { Mailer.expects(:deliver_order_updated).with(@order).never }
      should('return true') { assert @result }
    end

    context 'when distributor has changed' do
      setup { @order.distributor = Factory(:distributor) }

      context 'before_update' do
        setup { @result = observer.before_update(@order) }
        before_should('deliver notification') { Mailer.expects(:deliver_order_updated).with(@order) }
        should('return true') { assert @result }
      end
    end

    context 'before_destroy' do
      setup { @result = observer.before_destroy(@order) }
      before_should('deliver notification') { Mailer.expects(:deliver_order_destroyed).with(@order) }
      should('return true') { assert @result }
    end
  end

  context 'with an existing Shipment' do
    setup { @shipment = Factory.create(:shipment) }

    context 'after_create' do
      setup { observer.after_create(@shipment) }
      before_should('deliver notification') { Mailer.expects(:deliver_shipment_created).with(@shipment.order) }
    end

    context 'before_destroy' do
      setup { @result = observer.before_destroy(@shipment) }
      before_should('deliver notification') { Mailer.expects(:deliver_shipment_destroyed).with(@shipment.order) }
      should('return true') { assert @result }
    end
  end
end
