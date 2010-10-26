class Distributor::UserSessionsController < Distributor::ApplicationController
  skip_before_filter :require_current_user, :only => %w( new create )

  def new
    @user_session = UserSession.new(session)
  end

  def create
    @user_session = UserSession.new(session, params[:user_session])
    if @user_session.save
      redirect_to distributor_root_path
    else
      render :new
    end
  end

  def destroy
    current_user_session.destroy
    redirect_to distributor_root_path
  end
end
