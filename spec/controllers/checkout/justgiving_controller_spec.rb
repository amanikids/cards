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
    it 'loads the address from the session' do
      Address.stub(:find_by_id).with(42).and_return(address = stub)
      session[:address_id] = 42
      get :address, :store_id => store.slug
      assigns[:address].should == address
    end

    it "builds a new address when there's none in the session" do
      get :address, :store_id => store.slug
      assigns[:address].should be_a_new_record
    end
  end

  context 'PUT update_address' do
    it 'redirects to review when valid' do
      Address.stub(:new).and_return stub(:id => 42, :update_attributes => true)
      put :update_address, :store_id => store.slug
      response.should redirect_to(store_checkout_justgiving_review_path(store))
    end
  end

  context 'GET review' do
    it 'assigns to @order' do
      session[:address_id] = 42
      Address.stub(:find).with(42).and_return mock_model(Address)
      get :review, :store_id => store.slug
      assigns[:order].should be_a_new_record
    end
  end

  context 'GET complete' do
    def do_get(donation_identifier=42)
      session[:address_id] = 42
      Address.stub(:find).with(42).and_return mock_model(Address)
      get :complete, :store_id => store.slug, :donation_identifier => donation_identifier
    end

    it 'redirects to the store if not given a donation identifier' do
      do_get(nil)
      response.should redirect_to(store_root_path(store))
    end

    it 'creates an order' do
      lambda { do_get }.should change(Order, :count)
    end

    it 'redirects to the order' do
      do_get
      response.should redirect_to([store, assigns[:order]])
    end
  end
end

