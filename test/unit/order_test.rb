require 'test_helper'

class OrderTest < ActiveSupport::TestCase
  should_have_many :items

  context 'total' do
    should 'be zero if there are no items' do
      assert_equal Money.new(0), Order.new.total
    end

    should 'be delegates to items' do
      order = Order.new
      order.stubs(:items).returns [stub(:total => Money.new(3)), stub(:total => Money.new(4))]
      assert_equal Money.new(7), order.total
    end
  end
end
