class Checkout::JustgivingController < ApplicationController
  before_filter :load_store
  before_filter :build_order, :only => [:review]

  def create
    redirect_to :action => 'address'
  end

  def address
    @address = Address.new
  end

  def update_address
    redirect_to :action => 'review'
  end

  def review

  end

  private

  def load_store
    @store = Store.find_by_slug!(params[:store_id])
  end

  def build_order
    @order = Order.new
    # @order.address = `
    @order.cart = current_cart
  end
end
