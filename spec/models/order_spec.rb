require 'spec_helper'

describe Order do
  it_behaves_like 'a model with translated attributes'

  let 'order' do
    Order.make!
  end

  context 'scopes' do
    it 'shows shipped orders' do
      order = Order.make!(:shipped)
      chaff = Order.make!(:unshipped)
      Order.shipped.should == [order]
    end

    it 'shows unshipped orders' do
      order = Order.make!(:unshipped)
      chaff = Order.make!(:shipped)
      Order.unshipped.should == [order]
    end
  end

  context 'associations' do
    it { should belong_to(:address) }
    it { should belong_to(:cart) }
    it { should belong_to(:payment) }
    it { should have_one(:store) }
  end

  context 'attributes' do
    it { should respond_to(:items_attributes=) }
    it { should allow_mass_assignment_of(:items_attributes) }
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
