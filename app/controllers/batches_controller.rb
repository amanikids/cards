class BatchesController < ApplicationController
  before_filter :find_distributor
  before_filter :find_batch

  before_filter :require_owner_or_admin

  def show
    @order = @batch.order
  end

  def update
    @batch.ship!
    redirect_to(:action => 'show')
  end

  protected

  def find_distributor
    @distributor = Distributor.find_by_param(params[:distributor_id])
    raise ActiveRecord::RecordNotFound unless @distributor
  end

  def find_batch
    @batch = @distributor.batches.find(params[:id])
  end

  def require_owner_or_admin
    return false unless current_user == @distributor || !current_user.is_a?(Distributor)
  end
end
