class Checkout::PaypalController < ApplicationController
  before_filter :load_store
  before_filter :load_paypal_account
  before_filter :store_paypal_params_in_session, :only => :review

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
      redirect_to store_root_path(@store),
        :alert => t('flash.alert.paypal.error', :message => @result.message)
    end
  end

  def cancel
    redirect_to store_root_path(@store),
      :notice => t('flash.notice.paypal.cancel')
  end

  def review
    @result = @gateway.details_for(session[:paypal][:token])

    if @result.success?
      @order = Order.new
      @order.cart = current_cart
    else
      redirect_to store_root_path(@store),
        :alert => t('flash.alert.paypal.error', :message => @result.message)
    end
  end

  def confirm
    @result = @gateway.purchase(current_cart.total, session[:paypal])

    if @result.success?
      @order = Order.new
      @order.cart = current_cart
      @order.build_payment.tap do |payment|
        payment.details = PaypalPaymentDetails.new(session[:paypal])
      end
      @order.save!
      forget_current_cart
      forget_paypal_params
      redirect_to [@store, @order],
        :notice => t('flash.notice.order.create')
    else
      redirect_to store_root_path(@store),
        :alert => t('flash.alert.paypal.error', :message => @result.message)
    end
  end

  private

  def load_paypal_account
    @gateway = @store.paypal_account
  end

  def store_paypal_params_in_session
    if params[:token] && params[:PayerID]
      session[:paypal] = {
        :token    => params[:token],
        :payer_id => params[:PayerID]
      }
      redirect_to :action => 'review'
    end
  end

  def forget_paypal_params
    session.delete(:paypal)
  end
end
