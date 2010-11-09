class Checkout::JustgivingController < ApplicationController
  before_filter :load_store

  before_filter :build_address,
    :only => [:address, :update_address]

  verify :session => [:address_id],
    :only => [:review, :donate, :complete],
    :redirect_to => :address_path

  before_filter :build_order,
    :only => [:review, :donate, :complete]

  verify :params => [:donation_identifier],
    :add_flash => { :alert => I18n.t('controllers.checkout.justgiving_controller.not_in_progress') },
    :only => [:complete],
    :redirect_to => :error_path

  def create
    redirect_to :action => 'address'
  end

  def update_address
    if @address.update_attributes(params[:address])
      session[:address_id] = @address.id
      redirect_to store_checkout_justgiving_review_path(@store)
    else
      render 'address'
    end
  end

  def review
    # method must be here for before_filters to work?!
  end

  def donate
    redirect_to @store.account.redirect_url(
      @order.cart.total,
      store_checkout_justgiving_url(@store)
    )
  end

  def complete
    # Pre-save the payment. Should not be necessary, but I want to see why it
    # fails sometimes: http://partners.getexceptional.com/exceptions/5487130
    @order.payment.save!

    @order.save!
    forget_current_cart
    forget_address
    redirect_to [@store, @order], :notice => t('.order.created')
  end

  private

  def build_address
    @address ||= if session[:address_id]
                   Address.find_by_id(session[:address_id]) || Address.new
                 else
                   Address.new
                 end
  end

  def build_order
    @order = Order.new
    @order.address = Address.find(session[:address_id])
    @order.cart = current_cart
    @order.payment = JustgivingPayment.new.tap do |payment|
      payment.donation_identifier = params[:donation_identifier]
    end
  end

  def address_path
    store_checkout_justgiving_address_path(@store)
  end

  def error_path
    store_root_path(@store)
  end

  def forget_address
    session.delete(:address_id)
  end
end
