class ApplicationController < ActionController::Base
  protect_from_forgery

  private

  # Cart management ---------------------------------------------------
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

  def forget_current_cart
    session.delete(:cart_id)
  end

  # Loaders -----------------------------------------------------------
  def load_store
    @store = Store.find_by_slug!(params[:store_id])
  end

  # Translations ------------------------------------------------------
  def translate(key, options={})
    super scope_key_by_controller(key), options
  end

  alias :t :translate

  def scope_key_by_controller(key)
    if key.starts_with?('.')
      "controllers.#{self.class.name.underscore.tr('/', '.')}#{key}"
    else
      key
    end
  end
end
