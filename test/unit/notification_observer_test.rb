require 'test_helper'

class NotificationObserverTest < ActiveSupport::TestCase
  subject { NotificationObserver.instance }
  should_observe :order, :batch

  context 'with an existing Order' do
    setup { @order = Factory.create(:order) }

    context 'after_create' do
      setup { subject.after_create(@order) }
      before_should('deliver notification') { Mailer.expects(:deliver_order_created).with(@order) }
    end

    context 'before_update' do
      setup { @result = subject.before_update(@order) }
      before_should('not deliver notification') { Mailer.expects(:deliver_order_updated).with(@order).never }
      should('return true') { assert @result }
    end

    context 'when distributor has changed' do
      setup { @order.distributor = Factory(:distributor) }

      context 'before_update' do
        setup { @result = subject.before_update(@order) }
        before_should('deliver notification') { Mailer.expects(:deliver_order_updated).with(@order) }
        should('return true') { assert @result }
      end
    end

    context 'before_destroy' do
      setup { @result = subject.before_destroy(@order) }
      before_should('deliver notification') { Mailer.expects(:deliver_order_destroyed).with(@order) }
      should('return true') { assert @result }
    end
  end
end
