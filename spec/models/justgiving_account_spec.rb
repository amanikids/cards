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

  it 'builds a redirect url' do
    justgiving_account.redirect_url.should ==
      'http://v3.staging.justgiving.com/donation/direct/charity/42?frequency=single'
  end

  it 'builds a redirect url, appending and escaping any given parameters' do
    justgiving_account.redirect_url(:foo => 'has spaces').should ==
      'http://v3.staging.justgiving.com/donation/direct/charity/42?frequency=single&foo=has%20spaces'
  end
end
