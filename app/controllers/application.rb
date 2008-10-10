# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time

  # See ActionController::RequestForgeryProtection for details
  # Uncomment the :secret if you're not using the cookie session store
  protect_from_forgery # :secret => 'fb74f02b076de8573568ae3cc49f6967'

  # See ActionController::Base for details
  # Uncomment this to filter the contents of submitted sensitive data parameters
  # from your application log (in this case, all fields with names like "password").
  # filter_parameter_logging :password

  attr_reader   :current_cart, :current_currency, :current_user
  helper_method :current_cart, :current_currency, :current_user
  before_filter :load_current_cart, :load_current_currency, :load_current_user

  def current_cart=(cart)
    @current_cart = cart
    current_session = session || request.session
    current_session[:cart] = (cart.id if cart)
  end

  def current_currency=(currency)
    @current_currency = currency
    current_session = session || request.session
    current_session[:currency] = currency
  end

  def current_user=(user)
    @current_user = user
    current_session = session || request.session
    current_session[:user] = (user.id if user)
  end

  private

  def load_current_cart
    if session[:cart]
      self.current_cart = Order.find(session[:cart]) rescue nil
    end
  end

  def load_current_currency
    self.current_currency = session[:currency] || 'USD'
  end

  def load_current_user
    if session[:user]
      self.current_user = User.find(session[:user]) rescue nil
    end
  end
end
