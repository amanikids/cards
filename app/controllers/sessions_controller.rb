class SessionsController < ApplicationController
  def create
    if params[:existing].to_i.nonzero?
      login params[:email], params[:password]
    else
      redirect_to hash_for_new_user_path(:user => { :email => params[:email]})
    end
  end

  def destroy
    session[:user_id] = nil
    redirect_to login_path
  end

  private

  def login(email, password)
    user = User.authenticate(email, password)
    if user
      session[:user_id] = user.id
      redirect_to root_path
    else
      render :action => 'new'
    end
  end
end
