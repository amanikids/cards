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

    context 'before_destroy' do
      setup { @result = subject.before_destroy(@order) }
      before_should('deliver notification') { Mailer.expects(:deliver_order_destroyed).with(@order) }
      should('return true') { assert @result }
    end
  end
end
