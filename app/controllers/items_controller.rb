class ItemsController < ApplicationController
  def create
    self.current_cart ||= Cart.create
    self.current_cart.items.create(params[:item])
    redirect_to root_path
  end

  def destroy
    @item = current_cart.items.find(params[:id])
    @item.destroy
    redirect_to edit_cart_path
  end
end
