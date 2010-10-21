require 'spec_helper'

describe Cart do
  let(:cart) { Cart.make! }

  it { should have_many(:items) }

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
        :cart     => cart,
        :product  => Product.make!(:price => 1000),
        :quantity => 3
      )
    end

    cart.total.should == 6000
  end
end
