require 'test_helper'

class PaymentsControllerTest < ActionController::TestCase
  should_route :post, '/orders/12345/payment', :action => 'create', :id => '12345'

  context 'with an existing Order and PaymentMethod' do
    setup do
      @order          = Factory.create(:order)
      @payment_method = Factory.create(:payment_method)
    end

    context 'create' do
      setup { post :create, :id => @order.token, :payment => { :payment_method_id => @payment_method.id }}
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
end
