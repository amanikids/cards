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

  context '#compact!' do
    it 'combines items that reference the same packaging' do
      packaging_one = Packaging.make!
      packaging_two = Packaging.make!

      Item.make!(:cart => cart, :packaging => packaging_one, :quantity => 1)
      Item.make!(:cart => cart, :packaging => packaging_two, :quantity => 2)
      Item.make!(:cart => cart, :packaging => packaging_one, :quantity => 3)
      Item.make!(:cart => cart, :packaging => packaging_one, :quantity => 4)

      cart.compact!.reload

      cart.should have(2).items
      cart.items.find_by_packaging_id(packaging_one.id).quantity.should == 8
      cart.items.find_by_packaging_id(packaging_two.id).quantity.should == 2
    end
  end

  it 'is empty when it has no items' do
    cart.stub(:items).and_return([])
    cart.should be_empty
  end

  it 'is not empty when it has some items' do
    cart.stub(:items).and_return([:item])
    cart.should_not be_empty
  end

  it 'is mutable when it has no order' do
    cart.should be_mutable
  end

  it 'is not mutable when it has an order' do
    cart.stub(:order).and_return('AN ORDER')
    cart.should_not be_mutable
  end

  it 'is not mutable when assigned to an order (inverse_of)' do
    Order.new.cart = cart
    cart.should_not be_mutable
  end

  it 'totals up its items' do
    cart.stub(:items).and_return([
      stub(:price => 2000),
      stub(:price => 4000)
    ])

    cart.total.should == 6000
  end
end
