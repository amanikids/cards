require 'test_helper'

class DistributorTest < ActiveSupport::TestCase
  should_require_attributes :country_code, :currency
end