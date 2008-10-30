class DistributorsController < ApplicationController
  before_filter :ensure_current_user
  before_filter :load_distributor, :only => :show

  private

  def load_distributor
    @distributor = Distributor.find_by_param(params[:id])
  end
end
