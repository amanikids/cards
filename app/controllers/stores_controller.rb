class StoresController < ApplicationController
  def index
    @stores = Store.all
  end

  def show
    @store = Store.find_by_slug!(params[:store_id])
    # TODO store.products
    @products = Product.all
  end
end
