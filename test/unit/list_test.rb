require 'test_helper'

class ListTest < ActiveSupport::TestCase
  should_belong_to :distributor
  should_have_many :items, :dependent => :destroy
  should_only_allow_numeric_values_for :additional_donation_amount
  should_allow_values_for :additional_donation_amount, '', nil
  should_not_allow_values_for :additional_donation_amount, -1, :message => /greater than/
  should_not_allow_values_for :additional_donation_amount, 3.14, :message =>  /not a number/

  should 'convert additional_donation_amount before validation' do
    list = Factory.build(:list, :additional_donation_amount => ''); list.valid?
    assert_equal 0.to_money, list.additional_donation
  end

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

    context 'when there are items' do
      setup do
        @list.distributor.currency = 'GBP'
        @list.stubs(:items).returns [stub(:total => Money.new(3)), stub(:total => Money.new(4))]
      end

      should 'be delegated to items' do
        assert_equal Money.new(7).exchange_to('GBP'), @list.total
      end

      should 'be expressed in the proper currency' do
        assert_equal 'GBP', @list.total.currency
      end
    end

    context 'when there is an additional donation' do
      setup { @list.additional_donation_amount = 3 }
      should 'include additional donation' do
        assert_equal Money.new(300), @list.total
      end
    end
  end
end
