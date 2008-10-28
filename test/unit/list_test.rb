require 'test_helper'

class ListTest < ActiveSupport::TestCase
  should_belong_to :distributor
  should_have_many :items, :dependent => :destroy

  should 'delegate currency to distributor' do
    list = List.new
    list.stubs(:distributor).returns(stub(:currency => 'CURRENCY'))
    assert_equal 'CURRENCY', list.currency
  end

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
    setup { @list = Factory.build(:list) }

    should 'be zero if there are no items' do
      assert_equal Money.new(0), @list.total
    end

    should 'be delegated to items' do
      @list.distributor.currency = 'GBP'
      @list.stubs(:items).returns [stub(:total => Money.new(3)), stub(:total => Money.new(4))]
      assert_equal Money.new(7).exchange_to('GBP'), @list.total
      assert_equal 'GBP', @list.total.currency
    end
  end
end
