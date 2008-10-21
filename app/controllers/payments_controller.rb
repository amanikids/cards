class PaymentsController < ApplicationController
  # POSTs come from PayPal, not our own application.
  skip_before_filter :verify_authenticity_token

  before_filter :load_notification
  before_filter :load_order

  def create
    if @notification.acknowledge
      if @notification.complete?
        @order.update_attributes(:payment_method => 'paypal', :paid_at => Time.now)
      else
        # TODO put some sort of error handling in place
        logger.error("Failed to verify Paypal's notification, please investigate.")
      end
    end

    render :text => ''
  end

  private

  def load_notification
    @notification = ActiveMerchant::Billing::Integrations::Paypal::Notification.new(request.raw_post)
  end

  def load_order
    @order = Order.find_by_token(@notification.item_id)
  end
end
