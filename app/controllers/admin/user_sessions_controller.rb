class Admin::UserSessionsController < Admin::ApplicationController
  skip_before_filter :require_current_user, :only => [:new, :create]

  def new
    @user_session = UserSession.new(session)
  end

  def create
    @user_session = UserSession.new(session, params[:user_session])
    if @user_session.save
      redirect_to admin_root_path
    else
      render :new
    end
  end

  def destroy
    current_user_session.destroy
    redirect_to admin_root_path
  end
end
