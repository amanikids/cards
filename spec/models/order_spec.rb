require 'spec_helper'

describe Order do
  let(:order) { Order.make! }

  context 'scopes' do
    it 'shows shipped orders' do
      order = Order.make!(:shipped)
      chaff = Order.make!(:unshipped)

      Order.shipped.should include(order)
      Order.shipped.should_not include(chaff)
    end

    it 'shows unshipped orders' do
      order = Order.make!(:unshipped)
      chaff = Order.make!(:shipped)

      Order.unshipped.should include(order)
      Order.unshipped.should_not include(chaff)
    end
  end

  context 'associations' do
    it { should belong_to(:cart) }
    it { should belong_to(:payment) }
    it { should belong_to(:store) }
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
