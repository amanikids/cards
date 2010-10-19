class Checkout::PayPalsController < ApplicationController
  before_filter :build_pay_pal

  def create
    if @pay_pal.save
      redirect_to @pay_pal.url
    else
      # FIXME what to do?
    end
  end

  private

  def build_pay_pal
    @pay_pal = Checkout::PayPal.new(current_cart)
  end
end
