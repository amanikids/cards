class Admin::JustgivingAccountsController < Admin::ApplicationController
  before_filter :build_justgiving_account

  def create
    if @justgiving_account.save
      redirect_to admin_accounts_path, :notice => t('.create.success')
    else
      render 'new'
    end
  end

  private

  def build_justgiving_account
    @justgiving_account = JustgivingAccount.new(params[:justgiving_account])
  end
end

