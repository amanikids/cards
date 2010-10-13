class Admin::UserSessionsController < Admin::ApplicationController
  def new
    @user_session = UserSession.new(session)
  end

  def create
    @user_session = UserSession.new(session, params[:user_session])
    if @user_session.save
      redirect_to admin_products_path
    else
      render :new
    end
  end
end
