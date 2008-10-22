class PaymentsController < ApplicationController
  before_filter :load_parent_order
  before_filter :ensure_current_user, :only => :update

  def create
    @order.create_payment(params[:payment])
    redirect_to order_path(@order)
  end

  def update
    @order.payment.update_attributes(params[:payment].merge(:recipient => current_user))
    flash[:notice] = 'Payment updated.'
    redirect_to order_path(@order)
  end
end
