class Checkout::JustgivingController < ApplicationController
  before_filter :load_store
  before_filter :load_address, :only => %w(address update_address review)
  before_filter :build_order,  :only => %w(review)

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
  end

  def donate
  end

  def confirm
  end

  private

  def load_store
    @store = Store.find_by_slug!(params[:store_id])
  end

  def load_address
    @address ||= if session[:address_id]
                   Address.find_by_id(session[:address_id]) || Address.new
                 else
                   Address.new
                 end
  end

  def build_order
    @order = Order.new
    @order.address = @address
    @order.cart = current_cart
  end
end
