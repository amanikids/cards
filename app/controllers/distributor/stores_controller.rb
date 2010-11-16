class Distributor::StoresController < Distributor::ApplicationController
  def index
    @stores = current_user.stores.all
  end

  def show
    @store = current_user.stores.find_by_slug!(params[:id])
  end

  def shipped
    @store = current_user.stores.find_by_slug!(params[:id])
  end
end
