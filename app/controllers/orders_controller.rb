class OrdersController < ApplicationController
  def show
    @order = Order.find_by_token!(params[:id])
  end
end
