class Admin::PackagingsController < Admin::ApplicationController
  before_filter :load_product,
    :only => %w(new create)
  before_filter :build_packaging,
    :only => %w(new create)

  def create
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

  def build_packaging
    @packaging = @product.packagings.build(params[:packaging])
  end
end
