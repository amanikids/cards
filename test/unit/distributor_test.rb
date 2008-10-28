require 'test_helper'

class DistributorTest < ActiveSupport::TestCase
  should_have_many :carts
  should_have_many :orders

  should_require_attributes :country_code, :currency

  should 'delegate to_param to country_code' do
    distributor = Factory.build(:distributor, :country_code => 'COUNTRY_CODE')
    assert_equal 'COUNTRY_CODE', distributor.to_param
  end
end