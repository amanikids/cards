class SessionsController < ApplicationController
  def create
    if params[:existing].to_i.nonzero?
      login params[:email], params[:password]
    else
      redirect_to hash_for_new_user_path(:user => { :email => params[:email]})
    end
  end

  def destroy
    self.current_user = nil
    redirect_to root_path
  end

  private

  def login(email, password)
    user = User.authenticate(email, password)
    if user
      self.current_user = user
      redirect_to root_path
    else
      render :action => 'new'
    end
  end
end
