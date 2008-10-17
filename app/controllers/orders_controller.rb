class OrdersController < ApplicationController
  before_filter :ensure_current_cart
  before_filter :load_new_order

  private

  def load_new_order
    @order = current_cart
  end
end
