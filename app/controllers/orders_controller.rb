class OrdersController < ApplicationController
  before_filter :ensure_current_user, :only => :index
  before_filter :ensure_current_cart, :only => %w[new create]
  before_filter :load_new_order,      :only => %w[new create]
  before_filter :load_order,          :only => :show

  def create
    if @order.save
      redirect_to order_path(@order)
    else
      render :action => 'new'
    end
  end

  private

  def load_new_order
    @order = current_cart.build_order(params[:order])
  end

  def load_order
    @order = Order.find_by_token(params[:id])
  end
end
