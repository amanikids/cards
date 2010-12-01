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

    it 'generates the appropriate inventory transfers' do
      store = Store.make!

      product_one = Product.make!(:store => store)
      product_two = Product.make!(:store => store)

      cart = Cart.make!(:store => store)

      Item.make!(
        :cart => cart,
        :quantity => 2,
        :packaging => Packaging.make!(
          :size => 3,
          :product => product_one))

      Item.make!(
        :cart => cart,
        :quantity => 5,
        :packaging => Packaging.make!(
          :size => 7,
          :product => product_two))

      order = Order.make!(:cart => cart)

      product_one.quantity.should == -6
      product_two.quantity.should == -35
    end
  end

  it 'uses token for to_param' do
    order.to_param.should == order.token
  end
end
