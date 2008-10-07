class SessionsController < ApplicationController
  def create
    user = User.authenticate(params[:email], params[:password])
    if user
      session[:user_id] = user.id
      redirect_to root_path
    else
      render :action => 'new'
    end
  end
end
