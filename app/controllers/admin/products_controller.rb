class Admin::ProductsController < Admin::ApplicationController
  before_filter :load_store, :only => [:new, :create]

  def new
    @product = @store.products.build(params[:product])
  end

  def create
    @product = @store.products.build(params[:product])
    if @product.save
      redirect_to [:admin, @store], :notice => t('.create.success')
    else
      render 'new'
    end
  end

  def show
    @product = Product.find(params[:id])
  end

  def edit
    @product = Product.find(params[:id])
  end

  def update
    @product = Product.find(params[:id])

    if @product.update_attributes(params[:product])
      redirect_to [:admin, @product], :notice => t('.update.success')
    else
      render 'edit'
    end
  end

  private

  def load_store
    @store = Store.find_by_slug!(params[:store_id])
  end
end
