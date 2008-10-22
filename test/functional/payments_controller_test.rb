require 'test_helper'

class PaymentsControllerTest < ActionController::TestCase
  should_route :post, '/orders/12345/payment', :action => 'create', :order_id => '12345'
  should_route :put,  '/orders/12345/payment', :action => 'update', :order_id => '12345'

  context 'with an existing Order and PaymentMethod' do
    setup do
      @order          = Factory.create(:order)
      @payment_method = Factory.create(:payment_method)
    end

    context 'create' do
      setup { post :create, :order_id => @order.token, :payment => { :payment_method_id => @payment_method.id }}
      should_change '@order.reload.payment', :from => nil
      should_change 'Payment.count', :by => 1

      should 'create payment with the request method' do
        assert_equal @payment_method, @order.payment.payment_method
      end

      should 'not mark payment as received' do
        assert_nil @order.payment.received_at
      end

      should_redirect_to 'order_path(@order)'
    end
  end

  context 'with an existing Order and unreceived Payment' do
    setup { @payment = Factory.create(:payment, :received_at => nil, :recipient => nil) }

    context 'not logged in' do
      setup { @controller.current_user = nil }

      context 'update' do
        setup { put :update, :order_id => @payment.order.token, :payment => { :received_at => Time.now } }
        should_not_change '@payment.received_at'
        should_redirect_to 'new_session_path'
      end
    end

    context 'logged in' do
      setup { @controller.current_user = Factory.create(:user) }

      context 'update' do
        setup { put :update, :order_id => @payment.order.token, :payment => { :received_at => Time.now } }
        should_change '@payment.reload.received_at'
        should_change '@payment.reload.recipient', :from => nil
        should('set recipient to current_user') { assert_equal @controller.current_user, @payment.reload.recipient }
        should_set_the_flash_to 'Payment updated.'
        should_redirect_to 'order_path(@order)'
      end
    end
  end
end
