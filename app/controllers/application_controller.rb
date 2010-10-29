require 'concerns/controller_scoped_translations'

class ApplicationController < ActionController::Base
  include Concerns::ControllerScopedTranslations

  protect_from_forgery

  private

  # Cart management ---------------------------------------------------
  def current_cart
    @current_cart ||= if session[:cart_id]
                        @store.carts.find_by_id(session[:cart_id]) || @store.carts.build
                      else
                        @store.carts.build
                      end
  end

  helper_method :current_cart

  def ensure_current_cart_persisted
    return if current_cart.persisted?
    current_cart.save!
    session[:cart_id] = current_cart.id
  end

  def forget_current_cart
    session.delete(:cart_id)
  end

  # Loaders -----------------------------------------------------------
  def load_store
    @store = Store.find_by_slug!(params[:store_id])
  end
end
