class ItemsController < ApplicationController
  before_filter :ensure_current_cart_persisted
  before_filter :load_store

  def create
    current_cart.items.create!({ :quantity => 1 }.merge(params[:item]))
    redirect_to store_root_path(@store)
  end
end
