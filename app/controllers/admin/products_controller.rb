class Admin::ProductsController < Admin::ApplicationController
  before_filter :load_store

  def new
    @product = @store.products.build
  end

  def create
    @product = @store.products.build(params[:product])
    if @product.save
      redirect_to [:admin, @store]
    else
      render :new
    end
  end

  private

  def load_store
    @store = Store.find_by_slug!(params[:store_id])
  end
end
