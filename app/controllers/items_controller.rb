class ItemsController < ApplicationController
  def create
    self.current_cart ||= Order.create
    self.current_cart.items.create(params[:item])
    redirect_to root_path
  end
end
