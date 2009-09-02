require 'test_helper'

class PaypalDonationsControllerTest < ActionController::TestCase
  should_route :post, '/us/orders/12345/paypal_donation', :action => 'create', :order_id => '12345', :distributor_id => 'us'

  context 'with an existing Distributor' do
    setup { @distributor = Factory.create(:distributor) }

    context 'with an existing Order and PayPal DonationMethod' do
      setup do
        @order  = Factory.create(:order)
        @method = Factory.create(:paypal_donation_method)
      end

      context 'when we successfully acknowledge PayPal notification' do
        setup { ActiveMerchant::Billing::Integrations::Paypal::Notification.any_instance.stubs(:acknowledge).returns(true) }

        context 'the notification is complete' do
          setup do
            ActiveMerchant::Billing::Integrations::Paypal::Notification.any_instance.stubs(:complete?).returns(true)
            ActiveMerchant::Billing::Integrations::Paypal::Notification.any_instance.stubs(:received_at).returns(Time.now)
          end

          context 'and the notification is for our Order' do
            setup { ActiveMerchant::Billing::Integrations::Paypal::Notification.any_instance.stubs(:item_id).returns(@order.token) }

            context 'create' do
              setup { post :create, :distributor_id => @distributor.to_param, :order_id => @order.token, :donation_method_id => @method.id }
              should_change('@order.reload.donation', :from => nil) { @order.reload.donation }
              should_change('Donation.count', :by => 1) { Donation.count }

              should "set the donation_method field to PayPal" do
                assert_equal @method, @order.donation_method
              end

              should "set the donation_received_at field" do
                assert_not_nil @order.donation_received_at
              end
            end
          end

          context 'and the notification is for a different Order' do
            setup { ActiveMerchant::Billing::Integrations::Paypal::Notification.any_instance.stubs(:item_id).returns('not the right order token') }

            context 'create' do
              setup { post :create, :distributor_id => @distributor.to_param, :order_id => @order.token, :donation_method_id => @method.id }
              should_not_change('@order.reload.donation') { @order.reload.donation }
              should_not_change('Donation.count') { Donation.count }
            end
          end
        end
      end
    end
  end
end
