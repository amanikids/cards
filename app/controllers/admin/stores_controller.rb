class Admin::StoresController < Admin::ApplicationController
  before_filter :build_store,
    :only => %w(new create)

  def index
    @stores = Store.order(:name)
  end

  def create
    if @store.save
      redirect_to admin_stores_path, :notice => t('.create.success')
    else
      render 'new'
    end
  end

  def show
    @store = Store.find_by_slug!(params[:id])
  end

  private

  def build_store
    @store = Store.new(params[:store])

    if params_store = params[:store]
      if account_id = params_store[:account_id]
        @store.account = Account.find(account_id)
      end
    end
  end
end
