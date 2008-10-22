require 'test_helper'

class NotificationObserverTest < ActiveSupport::TestCase
  should_observe :list

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
end
