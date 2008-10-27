require 'test_helper'

class DistributorTest < ActiveSupport::TestCase
  should_have_many :carts
  should_have_many :orders

  should_require_attributes :country_code, :currency
end