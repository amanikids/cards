require 'spec_helper'

describe Checkout::PayPal do
  it_behaves_like 'an ActiveModel'

  context 'save' do
    it 'obtains a token from PayPal' do
      pay_pal = Checkout::PayPal.new(stub_model(Cart))

      body = Rack::Utils.build_query(:TOKEN => '42')
      stub_request(:post, 'https://api-3t.paypal.com/nvp').
        to_return(:body => body, :status => 200)

      pay_pal.save
      pay_pal.token.should == '42'
    end
  end
end
