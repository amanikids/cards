require 'test_helper'

class CartTest < ActiveSupport::TestCase
  should 'be donor_editable' do
    assert Cart.new.donor_editable?
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
end
