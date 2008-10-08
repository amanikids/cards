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

  attr_reader   :current_user
  helper_method :current_user
  before_filter :load_current_user

  private

  def current_user=(user)
    @current_user  = user
    session[:user] = user ? user.id : nil
  end

  def load_current_user
    self.current_user = User.find(session[:user]) if session[:user]
  end
end
