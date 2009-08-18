require 'test_helper'

class DistributorTest < ActiveSupport::TestCase
  should_have_many :carts
  should_have_many :donation_methods
  should_have_many :inventories
  should_have_many :orders

  should_validate_presence_of :country_code, :currency

  should 'delegate to_param to country_code' do
    distributor = Factory.build(:distributor, :country_code => 'COUNTRY_CODE')
    assert_equal 'COUNTRY_CODE', distributor.to_param
  end

  context 'with an existing Distributor' do
    setup { @distributor = Factory(:distributor) }

    context 'find_by_param' do
      should 'return distributor when find_by_param with to_param' do
        assert_equal @distributor, Distributor.find_by_param(@distributor.to_param)
      end

      should 'raise NotFound with find_by_param with something else' do
        assert_raise(ActiveRecord::RecordNotFound) do
          Distributor.find_by_param('NO DISTRIBUTOR SHOULD HAVE THIS TO_PARAM')
        end
      end
    end

    context 'update inventories' do
      setup { @inventory = Factory(:inventory, :distributor => @distributor) }

      should 'have the inventory' do
        assert_equal [@inventory], @distributor.inventories
      end

      context 'with valid attributes' do
        setup { @result = @distributor.update_inventories(@inventory.id => {'actual' => '200'}) }
        should('return true') { assert @result }
        should_change '@inventory.reload.actual', :to => 200
      end

      context 'with invalid attributes' do
        setup { @result = @distributor.update_inventories(@inventory.id => {'actual' => 'a'}) }
        should('return false') { assert !@result }
        should_not_change '@inventory.reload.actual'
      end
    end
  end
end