class Admin::AccountsController < Admin::ApplicationController
  def index
    @accounts = PaypalAccount.all.concat(JustgivingAccount.all).sort_by(&:created_at)
  end
end
