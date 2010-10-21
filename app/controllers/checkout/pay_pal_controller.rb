class Checkout::PayPalController < ApplicationController
  before_filter :build_gateway
  before_filter :store_params_in_session, :only => :review

  def create
    @result = @gateway.setup_purchase(
      current_cart.total,
      :return_url           => url_for(:action => 'review'),
      :cancel_return_url    => url_for(:action => 'cancel'),
      :allow_guest_checkout => true
    )

    if @result.success?
      redirect_to @gateway.redirect_url_for(@result.token)
    else
      redirect_to root_path, :alert => t('flash.alert.paypal.error')
    end
  end

  def cancel
    redirect_to root_path, :notice => t('flash.notice.paypal.cancel')
  end

  def review
    @result = @gateway.details_for(session[:paypal_token])

    if @result.success?
      @order = Order.new
      @order.cart = current_cart
    else
      redirect_to root_path, :alert => t('flash.alert.paypal.error')
    end
  end

  def confirm
    @result = @gateway.purchase(
      current_cart.total,
      :payer_id => session[:paypal_payer_id],
      :token    => session[:paypal_token]
    )

    if @result.success?
      @order = Order.new
      @order.cart = current_cart
      @order.build_payment.tap do |payment|
        payment.details = PayPalPaymentDetails.new(
          :payer_id => session[:paypal_payer_id],
          :token    => session[:paypal_token]
        )
      end
      @order.save
      redirect_to @order
    else
      redirect_to root_path, :alert => t('flash.alert.paypal.error')
    end
  end

  private

  def build_gateway
    @gateway = ActiveMerchant::Billing::PaypalExpressGateway.new(
      :login     => ENV['PAYPAL_LOGIN'],
      :password  => ENV['PAYPAL_PASSWORD'],
      :signature => ENV['PAYPAL_SIGNATURE']
    )
  end

  def store_params_in_session
    if params[:token] && params[:PayerID]
      session[:paypal_payer_id] = params[:PayerID]
      session[:paypal_token]    = params[:token]
      redirect_to :action => 'review'
    end
  end
end
