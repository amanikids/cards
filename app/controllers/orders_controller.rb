class OrdersController < ApplicationController
  before_filter :ensure_current_cart
  before_filter :ensure_address
  before_filter :load_cart

  private

  def ensure_address
    redirect_to new_address_path unless current_cart.address
  end

  def load_cart
    @cart = current_cart
  end
end
