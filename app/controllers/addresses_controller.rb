class AddressesController < ApplicationController
  before_filter :ensure_current_cart
  before_filter :load_new_address

  def create
    if @address.save
      redirect_to checkout_path
    else
      render :action => 'new'
    end
  end

  private

  def load_new_address
    @address = current_cart.build_address(params[:address])
  end
end
