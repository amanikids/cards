class OrdersController < ApplicationController
  before_filter :ensure_current_cart, :only => :new
  before_filter :ensure_address,      :only => :new
  before_filter :load_cart,           :only => :new
  before_filter :load_order,          :only => :show

  private

  def ensure_address
    redirect_to new_address_path unless current_cart.address
  end

  def load_cart
    @cart = current_cart
  end

  def load_order
    @order = Order.find_by_token(params[:id])
  end
end
