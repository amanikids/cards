class SessionsController < ApplicationController
  def create
    @user = User.authenticate(params[:email], params[:password])
    case @user
    when Distributor
      self.current_user = @user
      redirect_to distributor_path(@user)
    when User
      self.current_user = @user
      redirect_to distributors_path
    else
      render :action => 'new'
    end
  end

  def destroy
    self.current_user = nil
    redirect_to new_session_path
  end
end
