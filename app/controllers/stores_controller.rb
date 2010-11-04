class StoresController < ApplicationController
  before_filter :load_store, :only => :show

  def index
    @stores = Store.order(:name)
  end
end
