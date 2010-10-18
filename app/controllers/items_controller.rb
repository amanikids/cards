class ItemsController < ApplicationController
  before_filter :ensure_current_cart_persisted, :only => :create

  def create
    current_cart.items.create!({ :quantity => 1 }.merge(params[:item]))
    redirect_to root_path
  end
end
