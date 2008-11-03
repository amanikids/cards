class DistributorsController < ApplicationController
  before_filter :ensure_current_user
  before_filter :ensure_administrator, :only => :index
  before_filter :load_distributor, :except => :index
  before_filter :ensure_administrator_or_current_distributor, :except => :index

  def update
    if @distributor.update_inventories(params[:inventories])
      flash[:notice] = 'Inventory updated.'
      redirect_to distributor_path(@distributor)
    else
      render :action => 'show'
    end
  end

  private

  def ensure_administrator
    redirect_to distributor_path(current_user) if current_user.distributor?
  end

  def ensure_administrator_or_current_distributor
    redirect_to distributor_path(current_user) if current_user.distributor? && current_user != @distributor
  end

  def load_distributor
    @distributor = Distributor.find_by_param(params[:id])
  end
end
