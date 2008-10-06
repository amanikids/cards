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

  # TODO: I *really* ought to cache the current_cart.
  def current_cart
    if session[:cart_id]
      Order.find(session[:cart_id]) rescue Order.new
    else
      Order.new
    end
  end
  helper_method :current_cart

  def current_cart=(order)
    session[:cart_id] = order.id
  end
end
