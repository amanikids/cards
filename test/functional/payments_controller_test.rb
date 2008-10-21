require 'test_helper'

class PaymentsControllerTest < ActionController::TestCase
  should_route :post, '/payments', :action => 'create'

  context 'with an existing Order' do
    setup { @order = Factory.create(:order) }

    context 'when we successfully acknowledge PayPal notification' do
      setup { ActiveMerchant::Billing::Integrations::Paypal::Notification.any_instance.stubs(:acknowledge).returns(true) }

      context 'the notification is complete' do
        setup { ActiveMerchant::Billing::Integrations::Paypal::Notification.any_instance.stubs(:complete?).returns(true) }

        context 'and the notification is for our Order' do
          setup { ActiveMerchant::Billing::Integrations::Paypal::Notification.any_instance.stubs(:item_id).returns(@order.token) }

          context 'create' do
            setup { post :create }
            should_change '@order.reload.payment_method', :to => 'paypal'
            should_change '@order.reload.paid_at'
          end
        end
      end
    end
  end
end
