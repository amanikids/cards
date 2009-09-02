class ProductsController < ApplicationController
  def index
    @products = current_distributor.available_products + Product.on_demand
  end
end
