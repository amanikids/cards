require 'test_helper'

class AddressTest < ActiveSupport::TestCase
  should_require_attributes :name, :email, :line_one, :line_two, :country
  should_not_allow_values_for :email, 'this is not an email address'
end
