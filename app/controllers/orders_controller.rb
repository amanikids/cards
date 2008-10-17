class OrdersController < ApplicationController
  before_filter :ensure_current_cart
  before_filter :ensure_address
  before_filter :load_new_order

  private

  def ensure_address
    redirect_to new_address_path unless current_cart.address
  end

  def load_new_order
    @order = current_cart
  end
end
