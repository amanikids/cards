class PaymentsController < ApplicationController
  before_filter :load_order

  def create
    @order.create_payment(params[:payment])
    redirect_to order_path(@order)
  end

  private

  def load_order
    @order = Order.find_by_token(params[:id]) || raise(ActiveRecord::RecordNotFound)
  end
end
