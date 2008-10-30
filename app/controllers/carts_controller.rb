class CartsController < ApplicationController
  before_filter :ensure_current_cart
  before_filter :load_cart

  def update
    if @cart.update_attributes(params[:cart])
      flash[:notice] = 'Cart updated.'
      redirect_to cart_path(current_distributor)
    else
      render :action => 'show'
    end
  end

  private

  def load_cart
    @cart = current_cart
  end
end
