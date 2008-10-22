require 'test_helper'

class PaypalPaymentsControllerTest < ActionController::TestCase
  should_route :post, '/orders/12345/paypal_payment', :action => 'create', :order_id => '12345'

  context 'with an existing Order and PayPal PaymentMethod' do
    setup do
      Factory.create(:system_user)
      @order = Factory.create(:order)
      @method = Factory.create(:paypal_payment_method)
    end

    context 'when we successfully acknowledge PayPal notification' do
      setup { ActiveMerchant::Billing::Integrations::Paypal::Notification.any_instance.stubs(:acknowledge).returns(true) }

      context 'the notification is complete' do
        setup { ActiveMerchant::Billing::Integrations::Paypal::Notification.any_instance.stubs(:complete?).returns(true) }

        context 'and the notification is for our Order' do
          setup { ActiveMerchant::Billing::Integrations::Paypal::Notification.any_instance.stubs(:item_id).returns(@order.token) }

          context 'create' do
            setup { post :create, :order_id => @order.token }
            should_change '@order.reload.payment', :from => nil
            should_change 'Payment.count', :by => 1

            should "set the payment_method field to PayPal" do
              assert_equal @method, @order.payment_method
            end

            should "set the payment_received_at field" do
              assert_not_nil @order.payment_received_at
            end

            should "set the payment's recipient field" do
              assert_equal SystemUser.first, @order.payment_recipient
            end
          end
        end

        context 'and the notification is for a different Order' do
          setup { ActiveMerchant::Billing::Integrations::Paypal::Notification.any_instance.stubs(:item_id).returns('not the right order token') }

          context 'create' do
            setup { post :create, :order_id => @order.token }
            should_not_change '@order.reload.payment'
            should_not_change 'Payment.count'
          end
        end
      end
    end
  end
end
