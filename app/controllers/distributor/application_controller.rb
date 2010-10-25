class Distributor::ApplicationController < ApplicationController
  before_filter :require_current_user

  private

  def require_current_user
    redirect_to distributor_new_user_session_path unless current_user
  end

  def current_user
    @current_user ||= current_user_session.try(:user)
  end

  def current_user_session
    @current_user_session ||= UserSession.find(session)
  end

  helper_method :current_user
end
