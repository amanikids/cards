require 'test_helper'

class DistributorTest < ActiveSupport::TestCase
  should_have_many :carts
  should_have_many :distributor_donation_methods
  should_have_many :donation_methods, :through => :distributor_donation_methods
  should_have_many :orders

  should_require_attributes :country_code, :currency

  should 'delegate to_param to country_code' do
    distributor = Factory.build(:distributor, :country_code => 'COUNTRY_CODE')
    assert_equal 'COUNTRY_CODE', distributor.to_param
  end

  context 'with an existing Distributor' do
    setup { @distributor = Factory.create(:distributor) }

    should 'return distributor when find_by_param with to_param' do
      assert_equal @distributor, Distributor.find_by_param(@distributor.to_param)
    end

    should 'raise NotFound with find_by_param with something else' do
      assert_raise(ActiveRecord::RecordNotFound) do
        Distributor.find_by_param('NO DISTRIBUTOR SHOULD HAVE THIS TO_PARAM')
      end
    end
  end
end