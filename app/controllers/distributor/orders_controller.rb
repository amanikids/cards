class Distributor::OrdersController < Distributor::ApplicationController
  before_filter :load_store
  before_filter :load_order

  def update
    @order.shipped_at = Time.zone.now
    @order.save!
    redirect_to distributor_store_path(@store)
  end

  private

  def load_store
    @store = current_user.stores.find_by_slug!(params[:store_id])
  end

  def load_order
    @order = @store.orders.find_by_token!(params[:id])
  end
end
