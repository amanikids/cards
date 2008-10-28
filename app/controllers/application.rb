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

  attr_accessor :current_cart, :current_distributor, :current_user
  helper_method :current_cart, :current_distributor, :current_user

  before_filter :load_current_distributor
  before_filter :load_current_cart
  before_filter :load_current_user

  def current_cart=(cart)
    @current_cart = cart
    current_session[:cart] = cart ? cart.id : nil
  end

  def current_user=(user)
    @current_user = user
    current_session[:user] = user ? user.id : nil
  end

  private

  def current_session
    session || request.session
  end

  def load_current_cart
    if session[:cart]
      self.current_cart ||= current_distributor.carts.find(session[:cart]) rescue nil
    end
  end

  def load_current_distributor
    self.current_distributor ||= Distributor.find_by_param(params[:distributor_id]) if params[:distributor_id]
  end

  def load_current_user
    if session[:user]
      self.current_user ||= User.find(session[:user]) rescue nil
    end
  end

  def load_parent_order
    @order = Order.find_by_token(params[:order_id]) || raise(ActiveRecord::RecordNotFound)
  end

  def ensure_current_cart
    if current_cart.blank?
      flash[:notice] = 'Your cart is empty.'
      redirect_to distributor_root_path(current_distributor)
    end
  end

  def ensure_current_user
    if current_user.blank?
      flash[:notice] = 'Please log in.'
      redirect_to new_session_path
    end
  end
end
