class ItemsController < ApplicationController
  def create
    self.current_cart ||= current_distributor.carts.create
    self.current_cart.items.create(params[:item])
    redirect_to distributor_root_path(current_distributor)
  end

  def destroy
    @item = current_cart.items.find(params[:id])
    @item.destroy
    flash[:notice] = 'Item removed.'
    redirect_to cart_path(current_distributor)
  end
end
