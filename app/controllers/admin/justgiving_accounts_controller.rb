class Admin::JustgivingAccountsController < Admin::ApplicationController
  def new
    @justgiving_account = JustgivingAccount.new(params[:justgiving_account])
  end

  def create
    @justgiving_account = JustgivingAccount.new(params[:justgiving_account])
    if @justgiving_account.save
      redirect_to admin_accounts_path, :notice => t('.create.success')
    else
      render 'new'
    end
  end
end

