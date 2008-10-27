class CartsController < ApplicationController
  before_filter :ensure_current_cart
  before_filter :load_cart

  def update
    if @cart.update_items(params[:items])
      flash[:notice] = 'Cart updated.'
      redirect_to root_path
    else
      render :action => 'show'
    end
  end

  private

  def load_cart
    @cart = current_cart
  end
end
