class Admin::ProductsController < Admin::ApplicationController
  before_filter :load_store
  before_filter :build_product

  def create
    if @product.save
      redirect_to [:admin, @store], :notice => t('.create.success')
    else
      render 'new'
    end
  end

  private

  def load_store
    @store = Store.find_by_slug!(params[:store_id])
  end

  def build_product
    @product = @store.products.build(params[:product])
  end
end
