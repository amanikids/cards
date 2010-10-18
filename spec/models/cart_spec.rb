require 'spec_helper'

describe Cart do
  it_behaves_like 'an ActiveModel'

  let(:session) { Hash.new }

  it 'saves and retrieves empty carts from the session' do
    cart = Cart.new(session)
    cart.save
    Cart.find(session).should == cart
  end

  it 'saves and retrieves full carts from the session' do
    cart = Cart.new(session)
    cart.items.create(:product_id => 42)
  end
end
