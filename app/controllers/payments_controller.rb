class PaymentsController < ApplicationController
  before_filter :load_order
  before_filter :ensure_current_user, :only => :update

  def create
    @order.create_payment(params[:payment])
    redirect_to order_path(@order)
  end

  def update
    @order.payment.update_attributes(params[:payment])
    flash[:notice] = 'Payment updated.'
    redirect_to order_path(@order)
  end

  private

  def load_order
    @order = Order.find_by_token(params[:order_id]) || raise(ActiveRecord::RecordNotFound)
  end
end
