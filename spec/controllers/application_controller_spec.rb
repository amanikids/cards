require 'spec_helper'

describe ApplicationController do
  controller do
    before_filter :load_store

    def index
      @cart = current_cart
      render :text => ''
    end
  end

  let 'store' do
    # TODO set open in the blueprints. (But need to rename it for it to work!)
    Store.make!(:open => true)
  end

  it 'handles a missing cart id' do
    session[:cart_id] = -1
    get :index, :store_id => store.slug
    assigns[:cart].should_not be_nil
  end
end
