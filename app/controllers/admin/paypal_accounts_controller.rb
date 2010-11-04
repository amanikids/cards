class Admin::PaypalAccountsController < Admin::ApplicationController
  before_filter :build_paypal_account

  def create
    if @paypal_account.save
      redirect_to admin_accounts_path, :notice => t('.create.success')
    else
      render 'new'
    end
  end

  private

  def build_paypal_account
    @paypal_account = PaypalAccount.new(params[:paypal_account])
  end
end
