require 'spec_helper'

describe PaypalAccount do
  it_behaves_like 'a model with translated attributes'

  let 'paypal_account' do
    PaypalAccount.make!
  end

  let 'gateway' do
    mock 'Gateway'
  end

  let 'store' do
    stub_model Store, :currency => 'USD'
  end

  context 'associations' do
    it { should have_one(:store) }
  end

  context 'assignment' do
    it { should allow_mass_assignment_of(:login) }
    it { should allow_mass_assignment_of(:password) }
    it { should allow_mass_assignment_of(:signature) }
  end

  context 'validations' do
    it { should validate_presence_of(:login) }
    it { should validate_presence_of(:password) }
    it { should validate_presence_of(:signature) }
  end

  context 'setup_purchase' do
    it "uses the store's currency" do
      paypal_account.stub(:gateway).and_return(gateway)
      paypal_account.stub(:store).and_return(store)

      gateway.should_receive(:setup_purchase).with(10, hash_including(:currency => store.currency))

      paypal_account.setup_purchase(10)
    end
  end

  context 'purchase' do
    it "uses the store's currency" do
      paypal_account.stub(:gateway).and_return(gateway)
      paypal_account.stub(:store).and_return(store)

      gateway.should_receive(:purchase).with(10, hash_including(:currency => store.currency))

      paypal_account.purchase(10)
    end
  end

  context '#display_name' do
    it { paypal_account.display_name.should == paypal_account.login }
  end

  context '#type_slash_id' do
    it { paypal_account.type_slash_id.should == "PaypalAccount/#{paypal_account.id}" }
  end
end
