require 'spec_helper'

describe Cart do
  it_behaves_like 'a model with translated attributes'

  let 'cart' do
    Cart.make
  end

  context 'associations' do
    it { should belong_to(:store) }
    it { should have_many(:items) }
    it { should have_one(:order) }
  end

  it 'is empty when it has no items' do
    cart.stub(:items).and_return([])
    cart.should be_empty
  end

  it 'is not empty when it has some items' do
    cart.stub(:items).and_return([:item])
    cart.should_not be_empty
  end

  it 'totals up its items' do
    cart.stub(:items).and_return([
      stub(:price => 2000),
      stub(:price => 4000)
    ])

    cart.total.should == 6000
  end
end
