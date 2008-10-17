class OrdersController < ApplicationController
  before_filter :ensure_current_cart, :only => %w[new create]
  before_filter :ensure_address,      :only => %w[new create]
  before_filter :load_new_order,      :only => %w[new create]
  before_filter :load_order,          :only => %w[show]

  def create
    @order.confirm!
    redirect_to order_path(:id => @order.token)
  end

  private

  def ensure_address
    redirect_to new_address_path unless current_cart.address
  end

  def load_new_order
    @order = current_cart
  end

  def load_order
    @order = Order.find_by_token(params[:id]) || raise(ActiveRecord::RecordNotFound)
  end
end
