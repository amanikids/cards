class Admin::ProductsController < Admin::ApplicationController
  def index
    @products = Product.all
  end

  def new
    @product = Product.new
  end

  def create
    @product = Product.new(params[:product])
    if @product.save
      redirect_to :action => :index
    else
      render :new
    end
  end
end
