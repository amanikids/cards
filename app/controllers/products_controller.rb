class ProductsController < ApplicationController
  def index
    @products = Product.ordered
  end
end
