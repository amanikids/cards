require 'test_helper'

class CartTest < ActiveSupport::TestCase
  should 'not be confirmed' do
    assert !Cart.new.confirmed?
  end

  context 'with an existing cart' do
    setup { @cart = Factory.create(:cart) }

    context 'confirm' do
      setup { @cart.confirm! }
      should_change 'Cart.count', :by => -1
      should_change 'Order.count', :by => 1
    end

    context 'update items' do
      setup { @item = @cart.items.create!(:variant => Factory.create(:variant)) }

      context 'with valid attributes' do
        setup { @result = @cart.update_items(@item.id => {:quantity => 2}) }
        should('return true') { assert @result }
        should_change '@item.reload.quantity', :to => 2
      end

      context 'with invalid attributes' do
        setup { @result = @cart.update_items(@item.id => {:quantity => 'a'}) }
        should('return false') { assert !@result }
        should_not_change '@item.reload.quantity'
      end
    end
  end

  context 'with an existing Cart with nothing but downloadable items' do
    setup do
      Factory.create(:system_user)
      @cart = Factory.create(:cart)
      @cart.items << Factory.create(:item, :variant => Factory.create(:variant_with_download))
    end

    context 'confirm' do
      setup { @cart.confirm! }
      should_change 'Cart.count', :by => -1
      should_change 'Order.count', :by => 1
      should_change 'Shipment.count', :by => 1

      context 'order' do
        setup { @order = Order.find(@cart.id) }
        should('be shipped') { assert_not_nil @order.shipped_at }
        should('be shipped by the system') { assert_equal SystemUser.first, @order.shipper }
      end
    end
  end
end
