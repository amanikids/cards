class CartsController < ApplicationController
  before_filter :ensure_current_cart
  before_filter :load_cart

  def update
    if @cart.update_items(params[:items])
      redirect_to edit_cart_path
    else
      render :action => 'edit'
    end
  end

  private

  def ensure_current_cart
    unless current_cart
      flash[:notice] = 'Your cart is empty.'
      redirect_to root_path
    end
  end

  def load_cart
    @cart = current_cart
  end
end