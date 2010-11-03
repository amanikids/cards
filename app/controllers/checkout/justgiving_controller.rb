class Checkout::JustgivingController < ApplicationController
  before_filter :load_store

  before_filter :build_address,
    :only => %w(address update_address)

  verify :session => [:address_id],
    :only => %w(review donate complete),
    :redirect_to => :address_path

  before_filter :build_order,
    :only => %w(review donate complete)

  verify :params => [:donation_identifier],
    :add_flash => { :alert => I18n.t('controllers.checkout.justgiving.not_in_progress') },
    :only => %w(complete),
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
    # work done in before_filters; need a real method here for RSpec?
  end

  def donate
    redirect_to @store.account.redirect_url(
      @order.cart.total,
      store_checkout_justgiving_url(@store)
    )
  end

  def complete
    @order.save!
    forget_current_cart
    forget_address
    redirect_to [@store, @order], :notice => t('.order.created')
  end

  private

  def load_store
    @store = Store.find_by_slug!(params[:store_id])
  end

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
    @order.store = @store
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
