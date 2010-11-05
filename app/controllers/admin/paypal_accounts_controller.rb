class Admin::PaypalAccountsController < Admin::ApplicationController
  def new
    @paypal_account = PaypalAccount.new(params[:paypal_account])
  end

  def create
    @paypal_account = PaypalAccount.new(params[:paypal_account])
    if @paypal_account.save
      redirect_to admin_accounts_path, :notice => t('.create.success')
    else
      render 'new'
    end
  end
end
