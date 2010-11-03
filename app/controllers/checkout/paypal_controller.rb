class Checkout::PaypalController < ApplicationController
  before_filter :load_store
  before_filter :load_paypal_account

  verify :params => [:token, :PayerID], :only => [:review, :confirm],
    :add_flash   => { :alert => I18n.t('controllers.checkout.paypal_controller.not_in_progress') },
    :redirect_to => :error_path

  before_filter :build_order, :only => [:review, :confirm]

  def create
    result = @gateway.setup_purchase(
      current_cart.total,
      :return_url           => url_for(:action => 'review'),
      :cancel_return_url    => url_for(:action => 'cancel'),
      :allow_guest_checkout => true
    )

    if result.success?
      redirect_to @gateway.redirect_url_for(result.token)
    else
      redirect_to error_path, :alert => error_alert(result)
    end
  end

  def confirm
    result = @gateway.purchase(
      current_cart.total,
      :token    => params[:token],
      :payer_id => params[:PayerID]
    )

    if result.success?
      @order.save!
      forget_current_cart
      redirect_to [@store, @order], :notice => t('.order.created')
    else
      redirect_to error_path, :alert => error_alert(result)
    end
  end

  def cancel
    redirect_to error_path, :notice => t('.cancel')
  end

  private # --------------------------------------------------------------------

  def load_paypal_account
    @gateway = @store.account
  end

  def build_order
    result = @gateway.details_for(params[:token])

    unless result.success?
      redirect_to error_path, :alert => error_alert(result)
      return
    end

    @order = Order.new
    @order.address = Address.from_paypal_details(result.address)
    @order.cart    = current_cart
    @order.payment = PaypalPayment.new.tap do |payment|
      payment.token    = params[:token]
      payment.payer_id = params[:PayerID]
    end
  end

  def error_alert(result)
    t('.error', :message => result.message)
  end

  def error_path
    store_root_path(@store)
  end
end
