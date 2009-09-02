class ProductsController < ApplicationController
  def index
    @products = current_distributor.available_products
  end
end
