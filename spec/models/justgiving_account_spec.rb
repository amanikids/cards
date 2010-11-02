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
    uri_hash(justgiving_account.redirect_url(12, 'http://example.com')).should ==
      uri_hash('http://v3.staging.justgiving.com/donation/direct/charity/42?amount=12&exitUrl=http%3A%2F%2Fexample.com%3Fdonation_identifier%3DJUSTGIVING-DONATION-ID&frequency=single')
  end

  private

  def uri_hash(uri)
    uri = URI.parse(uri.to_s)
    {
      :host  => uri.host,
      :path  => uri.path,
      :query => Rack::Utils.parse_query(uri.query)
    }
  end
end
