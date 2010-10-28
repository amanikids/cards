class Admin::StoresController < Admin::ApplicationController
  def index
    @stores = Store.all
  end

  def show
    @store = Store.find_by_slug!(params[:id])
  end
end
