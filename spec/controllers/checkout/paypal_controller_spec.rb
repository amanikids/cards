require 'spec_helper'

describe Checkout::PaypalController do
  let 'paypal_account' do
    mock_model PaypalAccount
  end

  let 'store' do
    stub_model Store, :paypal_account => paypal_account, :slug => 'us'
  end

  before do
    Store.stub(:find_by_slug!).with(store.slug) { store }
  end

  context 'POST create' do
    it 'redirects to paypal on success' do
      paypal_account.stub(:setup_purchase) { success(:token => 42) }
      paypal_account.stub(:redirect_url_for).with(42) { 'URL' }
      post :create, :store_id => store.slug
      response.should redirect_to('URL')
    end

    it 'redirects to the store on failure' do
      paypal_account.stub(:setup_purchase) { failure(:message => 'BOOM') }
      post :create, :store_id => store.slug
      response.should redirect_to(store_root_path(store))
    end
  end

  context 'GET review' do
    it 'shows the order on success' do
      paypal_account.should_receive(:details_for).with(42) { success }
      get :review, :store_id => store.slug, :token => 42, :PayerID => 'BOB'
      assigns(:order).should be_a_new_record
    end

    it 'redirects to the store on failure' do
      paypal_account.should_receive(:details_for).with(42) { failure(:message => 'BOOM') }
      get :review, :store_id => store.slug, :token => 42, :PayerID => 'BOB'
      response.should redirect_to(store_root_path(store))
    end

    it 'redirects to the store if not given PayPal parameters' do
      get :review, :store_id => store.slug
      response.should redirect_to(store_root_path(store))
    end
  end

  context 'PUT confirm' do
    it 'redirects to the store on failure' do
      paypal_account.should_receive(:details_for).with(42) { success }
      paypal_account.should_receive(:purchase) { failure(:message => 'BOOM') }
      put :confirm, :store_id => store.slug, :token => 42, :PayerID => 'BOB'
      response.should redirect_to(store_root_path(store))
    end

    it 'redirects to the store if not given PayPal parameters' do
      put :confirm, :store_id => store.slug
      response.should redirect_to(store_root_path(store))
    end
  end

  context 'GET cancel' do
    it 'redirects to the store' do
      get :cancel, :store_id => store.slug
      response.should redirect_to(store_root_path(store))
    end
  end

  private

  def success(attributes={})
    stub attributes.merge(:success? => true)
  end

  def failure(attributes={})
    stub attributes.merge(:success? => false)
  end
end
