class PaypalPaymentsController < ApplicationController
  # POSTs come from PayPal, not our own application.
  skip_before_filter :verify_authenticity_token

  before_filter :load_notification
  before_filter :load_order
  before_filter :load_payment_method

  # TODO use a received_at timestamp from PayPal?
  def create
    @order.create_payment(:payment_method => @payment_method, :received_at => Time.now) if payment_received?
    render :text => ''
  end

  private

  def load_notification
    @notification = ActiveMerchant::Billing::Integrations::Paypal::Notification.new(request.raw_post)
  end

  def load_order
    @order = Order.find_by_token(params[:id]) || raise(ActiveRecord::RecordNotFound)
  end

  # TODO make a named scope for PaymentMethod.paypal?
  def load_payment_method
    @payment_method = PaymentMethod.find_by_name('paypal') || raise(ActiveRecord::RecordNotFound)
  end

  def payment_received?
    @notification.acknowledge && @notification.complete? && @order.token == @notification.item_id
  end
end
