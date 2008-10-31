class PaypalDonationsController < ApplicationController
  # POSTs come from PayPal, not our own application.
  skip_before_filter :verify_authenticity_token
  layout nil

  before_filter :load_notification
  before_filter :load_parent_order
  before_filter :load_donation_method

  def create
    if donation_received?
      @order.create_donation(:donation_method => @donation_method, :received_at => @notification.received_at)
    end
  end

  private

  def load_notification
    @notification = ActiveMerchant::Billing::Integrations::Paypal::Notification.new(request.raw_post)
  end

  def load_donation_method
    @donation_method = DonationMethod.find_by_name('paypal') || raise(ActiveRecord::RecordNotFound)
  end

  def donation_received?
    @notification.acknowledge && @notification.complete? && @order.token == @notification.item_id
  end
end
