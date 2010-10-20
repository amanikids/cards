class Checkout::PayPalController < ApplicationController
  before_filter :build_gateway

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
    @result = @gateway.details_for(params[:token])

    if @result.success?
      @order = Order.new(
        :cart  => current_cart,
        :email => @result.email,
        :address_attributes => @result.address,
        :payment_attribtues => {
          :token    => @result.token,
          :payer_id => @result.payer_id
        }
      )
    else
      redirect_to root_path, :alert => t('flash.alert.paypal.error')
    end
  end

  def confirm
    @order = Order.new(params[:order])

    if @order.valid?
      @result = @gateway.purchase(@order.total, @order.payment_attributes)

      if @result.success?
        @order.save
        redirect_to @order
      else
        redirect_to root_path, :alert => t('flash.alert.paypal.error')
      end
    else
      # FIXME do something!
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
end
