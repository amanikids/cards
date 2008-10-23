require 'test_helper'

class NotificationObserverTest < ActiveSupport::TestCase
  should_observe :order, :shipment

  context 'with a newly-created Order' do
    setup { @order = Factory.create(:order) }
    context 'after_create order' do
      setup { observer.after_create(@order) }
      before_should('deliver notification') { Mailer.expects(:deliver_order_thank_you).with(@order) }
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
