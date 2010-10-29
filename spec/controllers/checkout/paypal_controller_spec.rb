require 'spec_helper'

describe Checkout::PaypalController do
  let 'paypal_account' do
    mock_model PaypalAccount
  end

  let 'store' do
    paypal_account.stub(:set_store_target)
    stub_model Store, :account => paypal_account, :slug => 'us'
  end

  before do
    Store.stub(:find_by_slug!).with(store.slug) { store }
  end

  context 'POST create' do
    def do_post
      post :create, :store_id => store.slug
    end

    it 'redirects to paypal on success' do
      paypal_account.stub(:setup_purchase) { success(:token => 42) }
      paypal_account.stub(:redirect_url_for).with(42) { 'URL' }
      do_post
      response.should redirect_to('URL')
    end

    it 'redirects to the store on failure' do
      paypal_account.stub(:setup_purchase) { failure(:message => 'BOOM') }
      do_post
      response.should redirect_to(store_root_path(store))
    end
  end

  context 'GET review' do
    def do_get(token, payer_id='BOB')
      get :review, :store_id => store.slug, :token => token, :PayerID => payer_id
    end

    it 'shows the order on success' do
      paypal_account.should_receive(:details_for).with(42) { success(:address => {}) }
      do_get(42)
      assigns(:order).should be_a_new_record
    end

    it 'redirects to the store on failure' do
      paypal_account.should_receive(:details_for).with(42) { failure(:message => 'BOOM') }
      do_get(42)
      response.should redirect_to(store_root_path(store))
    end

    it 'redirects to the store if not given PayPal parameters' do
      do_get(nil, nil)
      response.should redirect_to(store_root_path(store))
    end
  end

  context 'PUT confirm' do
    def do_put(token, payer_id='BOB')
      put :confirm, :store_id => store.slug, :token => token, :PayerID => payer_id
    end

    it 'redirects to the store on failure' do
      paypal_account.should_receive(:details_for).with(42) { success(:address => {}) }
      paypal_account.should_receive(:purchase) { failure(:message => 'BOOM') }
      do_put(42)
      response.should redirect_to(store_root_path(store))
    end

    it 'redirects to the store if not given PayPal parameters' do
      do_put(nil, nil)
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
