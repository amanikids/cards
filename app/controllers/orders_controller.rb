class OrdersController < ApplicationController
  before_filter :ensure_current_cart, :only => %w[new create]
  before_filter :load_new_order,      :only => %w[new create]
  before_filter :ensure_current_user, :only => %w[update destroy]
  before_filter :load_order,          :only => %w[show update destroy]

  def create
    if @order.save
      self.current_cart.destroy
      self.current_cart = nil
      flash[:notice] = "<strong>Thanks, we've got it!</strong> See below to make your Donation."
      redirect_to order_path(current_distributor, @order)
    else
      flash.now[:error] = "Oops, make sure you've filled in all the required fields!"
      render :action => 'new'
    end
  end

  def destroy
    @order.destroy
    flash[:notice] = 'Order cancelled. An email has been sent to the Donor.'
    redirect_to distributor_path(current_distributor)
  end

  private

  def load_new_order
    params[:order] ||= {}
    params[:order][:address] ||= {}
    params[:order][:address][:country] ||= current_cart.distributor.country

    @order = current_cart.build_order(params[:order])
  end

  def load_order
    @order = Order.find_by_token(params[:id])
  end
end
