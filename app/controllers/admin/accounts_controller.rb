class Admin::AccountsController < Admin::ApplicationController
  def index
    @accounts = Account.all
  end
end
