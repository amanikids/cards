require 'spec_helper'

describe Cart do
  it { should have_many(:items) }

  it 'totals up its items' do
    cart = Cart.make!

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
