require 'spec_helper'

describe Order do
  let(:order) { Order.make! }

  context 'associations' do
    it { should belong_to(:cart) }
    it { should belong_to(:payment) }
  end

  context 'create' do
    it 'generates a random token' do
      order.token.should_not be_nil
    end
  end

  it 'uses token for to_param' do
    order.to_param.should == order.token
  end
end
