require 'test_helper'

class CartTest < ActiveSupport::TestCase
  context 'with an existing cart' do
    setup { @cart = Factory.create(:cart) }

    context 'update_attributes' do
      setup { @item = @cart.items.create!(:variant => Factory.create(:variant)) }

      context 'with valid attributes' do
        setup { @result = @cart.update_attributes(:items_attributes => [{:id => @item.id, :quantity => 2}]) }
        should('return true') { assert @result }
        should_change('@item.reload.quantity', :to => 2) { @item.reload.quantity }
      end

      context 'with invalid attributes' do
        setup { @result = @cart.update_attributes(:items_attributes => [{:id => @item.id, :quantity => 'a'}]) }
        should('return false') { assert !@result }
        should_not_change('@item.reload.quantity') { @item.reload.quantity }
      end
    end
  end
end
