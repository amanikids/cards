class Admin::UsersController < Admin::ApplicationController
  before_filter :build_user,
    :only => %w(new create)

  def index
    @users = User.order(:email)
  end

  def create
    @user.randomize_password!
    redirect_to admin_users_path, :notice => t('.create.success')
  rescue
    render 'new'
  end

  private

  def build_user
    @user = User.new(params[:user])
  end
end
