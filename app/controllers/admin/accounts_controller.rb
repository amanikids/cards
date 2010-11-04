class Admin::AccountsController < Admin::ApplicationController
  def index
    @accounts = PaypalAccount.all
  end
end
