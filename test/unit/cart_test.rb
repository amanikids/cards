require 'test_helper'

class CartTest < ActiveSupport::TestCase
  context '#compact!' do
    should 'combine items pointing to the same variant' do
      product = Factory.create(:product)
      a_10_pack = Factory.create(:variant, :size => 10, :product => product)
      a_25_pack = Factory.create(:variant, :size => 25, :product => product)

      cart = Factory.create(:cart)
      item_one   = cart.items.create!(:variant => a_10_pack)
      item_two   = cart.items.create!(:variant => a_25_pack)
      item_three = cart.items.create!(:variant => a_10_pack)

      cart.compact!

      item_one.reload.quantity.should == 2
      item_two.reload.quantity.should == 1

      lambda {
        item_three.reload
      }.should raise_error(ActiveRecord::RecordNotFound)
    end
  end

  context '#update_attributes' do
    setup do
      @cart = Factory.create(:cart)
      @item = @cart.items.create!(:variant => Factory.create(:variant))
    end

    context 'with valid items_attributes' do
      setup { @result = @cart.update_attributes(:items_attributes => [{:id => @item.id, :quantity => 2}]) }
      should('return true') { assert @result }
      should_change('@item.reload.quantity', :to => 2) { @item.reload.quantity }
    end

    context 'with invalid items_attributes' do
      setup { @result = @cart.update_attributes(:items_attributes => [{:id => @item.id, :quantity => 'a'}]) }
      should('return false') { assert !@result }
      should_not_change('@item.reload.quantity') { @item.reload.quantity }
    end
  end
end
