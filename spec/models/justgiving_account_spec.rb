require 'spec_helper'

describe JustgivingAccount do
  it_behaves_like 'a model with translated attributes'

  let 'justgiving_account' do
    JustgivingAccount.make!(:charity_identifier => 42)
  end

  context 'associations' do
    it { should have_one(:store) }
  end

  context 'assignment' do
    it { should allow_mass_assignment_of(:charity_identifier) }
  end

  context 'validations' do
    it { should validate_presence_of(:charity_identifier) }
  end

  it 'builds a redirect url, converting shillings to pounds' do
    justgiving_account.redirect_url(1200, 'http://example.com').should be_a_url_like('http://v3.staging.justgiving.com/donation/direct/charity/42?amount=12&exitUrl=http%3A%2F%2Fexample.com%3Fdonation_identifier%3DJUSTGIVING-DONATION-ID&frequency=single')
  end

  context '#display_name' do
    it { justgiving_account.display_name.should == justgiving_account.charity_identifier }
  end

  context '#type_slash_id' do
    it { justgiving_account.type_slash_id.should == "JustgivingAccount/#{justgiving_account.id}" }
  end
end
