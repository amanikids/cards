class Checkout::PayPalController < ApplicationController
  def create
    set_up_purchase(current_cart.total) do |result|
      if result.success?
        redirect_to gateway.redirect_url_for(result.token)
      else
        # FIXME set a proper flash notice
        redirect_to root_path
      end
    end
  end

  def callback
    look_up_details(params[:token]) do |result|
      if result.success?
        # TODO save address, save other things?
        # TODO redirect to review
        render :text => result.inspect
      else
        redirect_to root_path, :error => 'FIXME'
      end
    end
  end

  def cancel
    redirect_to root_path, :error => 'FIXME'
  end

  def review

  end

  def confirm
    purchase(current_cart.total) do |result|
      if result.success?
        # TODO figure out what to do
      else
        redirect_to root_path, :error => 'FIXME'
      end
    end
  end

  private

  # TODO will need to use different credentials for different countries
  # TODO may need to extend PaypalExpressGateway for different countries
  def gateway
    @gateway ||= ActiveMerchant::Billing::PaypalExpressGateway.new(
      :login     => ENV['PAYPAL_LOGIN'],
      :password  => ENV['PAYPAL_PASSWORD'],
      :signature => ENV['PAYPAL_SIGNATURE']
    )
  end

  def set_up_purchase(total, &block)
    gateway.setup_purchase(total,
      :return_url           => url_for(:action => 'callback'),
      :cancel_return_url    => url_for(:action => 'cancel'),
      :allow_guest_checkout => true
    ).tap(&block)
  end

  def look_up_details(token, &block)
    gateway.details_for(token).tap(&block)
  end
end
