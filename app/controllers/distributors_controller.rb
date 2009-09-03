class DistributorsController < ApplicationController
  before_filter :ensure_current_user
  before_filter :ensure_administrator, :only => :index
  before_filter :load_distributor, :except => :index
  before_filter :ensure_administrator_or_current_distributor, :except => :index

  before_filter :find_batches, :only => %w[show]

  def show
  end

  def update
    if @distributor.update_inventories(params[:inventories])
      flash[:notice] = 'Inventory updated.'
      redirect_to distributor_path(@distributor)
    else
      find_batches
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

  def find_batches
    # TODO Nicer includes. Part of the problem here is that current currency
    # is stored in the model, so items has to come back to the distributor
    # to get the price.
    common_includes = {:include => {
      :items => {
        :list => [
          :distributor,
          :address,
          :donation_method,
          {:items =>
            [{:list => :distributor}, :variant]}]}}}
    @unshipped = @distributor.batches.unshipped.find(:all, common_includes)
    @shipped   = @distributor.batches.shipped.find(:all, common_includes)
  end
end
