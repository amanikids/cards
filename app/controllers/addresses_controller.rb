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
    @address = Address.new(params[:address])
    @address.list = current_cart
  end
end
