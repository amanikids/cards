class DistributorsController < ApplicationController
  before_filter :ensure_current_user
  before_filter :load_distributor, :except => :index

  def update
    if @distributor.update_inventories(params[:inventories])
      flash[:notice] = 'Inventory updated.'
      redirect_to distributor_path(@distributor)
    else
      render :action => 'show'
    end
  end

  private

  def load_distributor
    @distributor = Distributor.find_by_param(params[:id])
  end
end
