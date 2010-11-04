class ItemsController < ApplicationController
  before_filter :load_store
  before_filter :ensure_current_cart_persisted

  def create
    current_cart.items.create!(params[:item])
    current_cart.compact!
    redirect_to store_root_path(@store)
  end

  def destroy
    @item = current_cart.items.find(params[:id])
    @item.destroy
    redirect_to store_root_path(@store)
  end
end
