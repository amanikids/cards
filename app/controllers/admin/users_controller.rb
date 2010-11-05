class Admin::UsersController < Admin::ApplicationController
  def index
    @users = User.order(:email)
  end

  def new
    @user = User.new(params[:user])
  end

  def create
    @user = User.new(params[:user])
    @user.randomize_password!
    redirect_to admin_users_path, :notice => t('.create.success')
  rescue
    render 'new'
  end
end
