class SessionsController < ApplicationController
  def create
    @user = User.authenticate(params[:email], params[:password])
    if @user
      self.current_user = @user
      redirect_to orders_path
    else
      render :action => 'new'
    end
  end

  def destroy
    self.current_user = nil
    redirect_to new_session_path
  end
end
