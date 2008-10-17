require 'test_helper'

class ListTest < ActiveSupport::TestCase
  should_have_one :address
  should_have_many :items

  context 'quantity' do
    should 'be zero if there are no items' do
      assert_equal 0, List.new.quantity
    end

    should 'be delegated to items' do
      list = List.new
      list.stubs(:items).returns [stub(:quantity => 3), stub(:quantity => 4)]
      assert_equal 7, list.quantity
    end
  end

  context 'total' do
    should 'be zero if there are no items' do
      assert_equal Money.new(0), List.new.total
    end

    should 'be delegated to items' do
      list = List.new
      list.stubs(:items).returns [stub(:total => Money.new(3)), stub(:total => Money.new(4))]
      assert_equal Money.new(7), list.total
    end
  end
end
