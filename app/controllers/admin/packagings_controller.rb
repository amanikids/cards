class Admin::PackagingsController < Admin::ApplicationController
  before_filter :load_product, :only => [:new, :create]

  def new
    @packaging = @product.packagings.build(params[:packaging])
  end

  def create
    @packaging = @product.packagings.build(params[:packaging])
    if @packaging.save
      redirect_to [:admin, @product], :notice => t('.create.success')
    else
      render 'new'
    end
  end

  private

  def load_product
    @product = Product.find(params[:product_id])
  end
end
