class ItemsController < ApplicationController
  def create
    self.current_cart ||= Cart.create
    self.current_cart.items.create(params[:item])
    redirect_to root_path
  end

  def destroy
    @item = current_cart.items.find(params[:id])
    @item.destroy
    flash[:notice] = 'Item removed.'
    redirect_to cart_path
  end
end
