class Admin::TransfersController < Admin::ApplicationController
  before_filter :load_product, :only => [:new, :create]

  def new
    @transfer = @product.transfers.build(params[:transfer])
  end

  def create
    @transfer = @product.transfers.build(params[:transfer])

    if @transfer.save
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
