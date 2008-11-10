class ShipmentsController < ApplicationController
  before_filter :ensure_current_user
  before_filter :load_parent_order

  def create
    @order.create_shipment
    flash[:notice] = 'Shipment recorded. An email has been sent to the Donor.'
    redirect_to order_path(current_distributor, @order)
  end

  def destroy
    @order.shipment.destroy
    flash[:notice] = 'Shipment cancelled. An email has been sent to the Donor.'
    redirect_to order_path(current_distributor, @order)
  end
end
