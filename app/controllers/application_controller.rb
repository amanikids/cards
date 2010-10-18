class ApplicationController < ActionController::Base
  protect_from_forgery

  private

  def current_cart
    @current_cart ||= begin
                        if session[:cart_id]
                          Cart.find(session[:cart_id])
                        else
                          Cart.new
                        end
                      end
  end

  helper_method :current_cart

  def ensure_current_cart_persisted
    return if current_cart.persisted?
    current_cart.save!
    session[:cart_id] = current_cart.id
  end
end
