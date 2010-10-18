class ApplicationController < ActionController::Base
  protect_from_forgery

  private

  def current_cart
    @current_cart ||= Cart.find(session[:cart_id])
  end

  helper_method :current_cart
end
