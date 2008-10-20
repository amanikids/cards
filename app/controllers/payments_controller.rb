class PaymentsController < ApplicationController
  def create
    if @notification.acknowledge
      if @notification.complete?
        @cart.confirm!
      else
        # TODO put some sort of error handling in place
        logger.error("Failed to verify Paypal's notification, please investigate.")
      end
    end

    render :nothing
  end

  private

  def load_notification
    @notification = ActiveMerchant::Billing::Integrations::Paypal::Notification.new(request.raw_post)
  end

  def load_cart
    @cart = Cart.find(@notification.item_id)
  end
end
