class ShipmentsController < ApplicationController
  before_filter :ensure_current_user
  before_filter :load_parent_order

  def create
    @order.create_shipment
    redirect_to order_path(current_distributor, @order)
  end
end
