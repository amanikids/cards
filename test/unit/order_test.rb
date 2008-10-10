require 'test_helper'

class OrderTest < ActiveSupport::TestCase
  should_have_many :items

  context 'quantity' do
    should 'be zero if there are no items' do
      assert_equal 0, Order.new.quantity
    end

    should 'be delegated to items' do
      order = Order.new
      order.stubs(:items).returns [stub(:quantity => 3), stub(:quantity => 4)]
      assert_equal 7, order.quantity
    end
  end

  context 'total' do
    should 'be zero if there are no items' do
      assert_equal Money.new(0), Order.new.total
    end

    should 'be delegated to items' do
      order = Order.new
      order.stubs(:items).returns [stub(:total => Money.new(3)), stub(:total => Money.new(4))]
      assert_equal Money.new(7), order.total
    end
  end
end
