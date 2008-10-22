require 'test_helper'

class ListTest < ActiveSupport::TestCase
  should_belong_to :address
  should_have_many :items

  context 'with an unsaved list' do
    setup { @list = Factory.build(:list) }
    context 'saving' do
      setup { @list.save }
      should_change '@list.token', :from => nil
    end
  end

  context 'a List' do
    setup { @list = List.new }
    should('not be immediately shippable') { assert !@list.immediately_shippable? }
    should('not have any downloads') { assert_equal [], @list.downloads }

    context 'with some items downloadable, some not' do
      setup { @list.stubs(:items).returns [stub(:download => nil), stub(:download => 'DOWNLOAD_TWO')] }
      should('not be immediately shippable') { assert !@list.immediately_shippable? }
      should('collect downloadable variants') { assert_equal ['DOWNLOAD_TWO'], @list.downloads }
    end

    context 'with all items downloadable' do
      setup { @list.stubs(:items).returns [stub(:download => 'DOWNLOAD_ONE'), stub(:download => 'DOWNLOAD_TWO')] }
      should('be immediately shippable') { assert @list.immediately_shippable? }
      should('collect downloadable variants') { assert_equal ['DOWNLOAD_ONE', 'DOWNLOAD_TWO'], @list.downloads }
    end
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

  context 'to_param' do
    should 'answer token' do
      order = Factory.build(:list, :token => :token)
      assert_equal :token, order.to_param
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
