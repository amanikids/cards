class OrdersController < ApplicationController
  before_filter :load_store

  def show
    @order = @store.orders.find_by_token!(params[:id])
  end
end
