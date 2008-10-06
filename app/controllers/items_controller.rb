class ItemsController < ApplicationController
  def create
    create_cart_if_necessary.items.create params[:item]
    flash[:notice] = 'Cart updated.'
    redirect_to root_path
  end

  private

  def create_cart_if_necessary
    self.current_cart = Order.create if current_cart.new_record?
    self.current_cart
  end
end
