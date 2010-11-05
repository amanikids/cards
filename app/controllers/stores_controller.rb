class StoresController < ApplicationController
  before_filter :load_store, :only => :show

  def index
    @stores = Store.active.order(:name)
  end

  def show
    # work done in before_filters; need this method for it to work?!
  end
end
