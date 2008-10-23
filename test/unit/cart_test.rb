require 'test_helper'

class CartTest < ActiveSupport::TestCase
  context 'with an existing cart' do
    setup { @cart = Factory.create(:cart) }

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
