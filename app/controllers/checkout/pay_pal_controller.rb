class Checkout::PayPalController < ApplicationController
  before_filter :build_gateway

  def create
    @result = @gateway.setup_purchase(
      current_cart.total,
      :return_url           => url_for(:action => 'callback'),
      :cancel_return_url    => url_for(:action => 'cancel'),
      :allow_guest_checkout => true
    )

    if @result.success?
      redirect_to @gateway.redirect_url_for(@result.token)
    else
      redirect_to root_path, :alert => t('flash.alert.paypal.error')
    end
  end

  def callback
    @result = @gateway.details_for(params[:token])

    if @result.success?
      render :text => @result.inspect
    else
      redirect_to root_path, :alert => t('flash.alert.paypal.error')
    end
  end

  def cancel
    redirect_to root_path, :notice => t('flash.notice.paypal.cancel')
  end

  private

  def build_gateway
    @gateway = ActiveMerchant::Billing::PaypalExpressGateway.new(
      :login     => ENV['PAYPAL_LOGIN'],
      :password  => ENV['PAYPAL_PASSWORD'],
      :signature => ENV['PAYPAL_SIGNATURE']
    )
  end
end
