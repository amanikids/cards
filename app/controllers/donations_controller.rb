class DonationsController < ApplicationController
  before_filter :load_parent_order
  before_filter :ensure_current_user, :only => :update

  def create
    @order.create_donation(params[:donation])
    redirect_to order_path(current_distributor, @order)
  end

  def update
    @order.donation.update_attributes(params[:donation].merge(:recipient => current_user))
    flash[:notice] = 'Donation updated.'
    redirect_to order_path(current_distributor, @order)
  end
end
