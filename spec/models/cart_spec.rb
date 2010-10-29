require 'spec_helper'

describe Cart do
  it_behaves_like 'a model with translated attributes'

  let 'cart' do
    Cart.make!
  end

  context 'associations' do
    it { should belong_to(:store) }
    it { should have_many(:items) }
    it { should have_one(:order) }
  end

  it 'is empty when it has no items' do
    cart.should be_empty
  end

  it 'is not empty when it has some items' do
    Item.make!(:cart => cart)
    cart.should_not be_empty
  end

  it 'totals up its items' do
    2.times do
      Item.make!(
        :cart      => cart,
        :packaging => Packaging.make!(:price => 1000),
        :quantity  => 3
      )
    end

    cart.total.should == 6000
  end
end
