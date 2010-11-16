class Admin::StoresController < Admin::ApplicationController
  def index
    @stores = Store.order(:name)
  end

  def new
    @store = Store.new(params[:store])
  end

  def create
    @store = Store.new(params[:store])
    if @store.save
      redirect_to admin_stores_path, :notice => t('.create.success')
    else
      render 'new'
    end
  end

  def show
    @store = Store.find_by_slug!(params[:id])
  end

  def edit
    @store = Store.find_by_slug!(params[:id])
  end

  def update
    @store = Store.find_by_slug!(params[:id])
    if @store.update_attributes(params[:store])
      redirect_to admin_store_path(@store), :notice => t('.update.success')
    else
      render 'edit'
    end
  end
end
