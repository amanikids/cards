require 'test_helper'

class NotificationObserverTest < ActiveSupport::TestCase
  should_observe :list, :shipment

  context 'with an existing Cart' do
    setup { @cart = Factory.create(:cart) }

    context 'that has just become an Order' do
      setup { @cart.confirm! }

      context 'after_update cart' do
        setup { observer.after_update(@cart) }
        before_should('deliver notification') { Mailer.expects(:deliver_order_thank_you).with(Order.find(@cart.id)) }
      end
    end
  end

  context 'with a newly-created Shipment' do
    setup { @shipment = Factory.create(:shipment) }

    context 'after_create shipment' do
      setup { observer.after_create(@shipment) }
      before_should('deliver notification') { Mailer.expects(:deliver_order_shipped).with(@shipment.order) }
    end
  end
end
