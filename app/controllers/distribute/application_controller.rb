class Distribute::ApplicationController < ApplicationController
  # TODO is there a nice way to pass a parameter to a before filter?
  before_filter :require_current_user

  private

  def require_current_user
    unless current_user
      redirect_to distribute_new_user_session_path
      return
    end

    unless current_user.distributor?
      redirect_to distribute_new_user_session_path,
        :alert => t('controllers.distribute.application.distributor_required')
    end
  end

  def current_user
    @current_user ||= current_user_session.try(:user)
  end

  def current_user_session
    @current_user_session ||= UserSession.find(session)
  end

  helper_method :current_user
end
