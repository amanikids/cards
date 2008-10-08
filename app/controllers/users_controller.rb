class UsersController < ApplicationController
  layout 'sessions'

  def new
    @user = User.new(params[:user])
  end

  def create
    @user = User.new(params[:user])
    if @user.save
      session[:user_id] = @user.id
      redirect_to root_path
    else
      render :action => 'new'
    end
  end
end
