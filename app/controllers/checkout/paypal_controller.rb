class Checkout::PaypalController < ApplicationController
  before_filter :load_store
  before_filter :load_paypal_account

  verify :params => [:token, :PayerID], :only => [:review, :confirm],
    :add_flash   => { :alert => I18n.t('flash.checkout.paypal.not_in_progress') },
    :redirect_to => :error_path

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
      redirect_to error_path, :alert => error_alert(@result)
    end
  end

  # TODO review and confirm should both look up the details! They will use the
  # same method to build up the order, so that I don't have to pass all those
  # parameters around.
  def review
    @result = @gateway.details_for(params[:token])

    if @result.success?
      @order = Order.new
      @order.cart = current_cart
    else
      redirect_to error_path, :alert => error_alert(@result)
    end
  end

  def confirm
    @result = @gateway.purchase(
      current_cart.total,
      :token    => params[:token],
      :payer_id => params[:PayerID]
    )

    if @result.success?
      @order = Order.new
      @order.cart = current_cart
      @order.build_payment.tap do |payment|
        payment.details = PaypalPaymentDetails.new(:token => params[:token], :payer_id => params[:PayerID])
      end
      @order.save!
      forget_current_cart
      redirect_to [@store, @order], :notice => t('flash.checkout.paypal.order.created')
    else
      redirect_to error_path, :alert => error_alert(@result)
    end
  end

  def cancel
    redirect_to error_path, :notice => t('flash.checkout.paypal.cancel')
  end

  private

  def load_paypal_account
    @gateway = @store.paypal_account
  end

  def error_alert(result)
    t('flash.checkout.paypal.error', :message => result.message)
  end

  def error_path
    store_root_path(@store)
  end
end
