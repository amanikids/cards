require 'spec_helper'

describe Checkout::JustgivingController do
  let 'justgiving_account' do
    mock_model JustgivingAccount
  end

  let 'store' do
    justgiving_account.stub(:set_store_target)
    stub_model Store, :account => justgiving_account, :slug => 'uk'
  end

  before do
    Store.stub(:find_by_slug!).with(store.slug).and_return(store)
  end

  context 'POST create' do
    it 'redirects to address' do
      post :create, :store_id => store.slug
      response.should redirect_to(store_checkout_justgiving_address_path(store))
    end
  end

  context 'GET address' do
    it 'assigns to @address' do
      get :address, :store_id => store.slug
      assigns[:address].should be_a_new_record
    end
  end

  context 'PUT update_address' do
    it 'redirects to review' do
      put :update_address, :store_id => store.slug
      response.should redirect_to(store_checkout_justgiving_review_path(store))
    end
  end

  context 'GET review' do
    it 'assigns to @order' do
      get :review, :store_id => store.slug
      assigns[:order].should be_a_new_record
    end
  end
end

