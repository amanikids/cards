require 'test_helper'

class AddressTest < ActiveSupport::TestCase
  should_validate_presence_of :name, :email, :line_one, :line_two, :country
  should_not_allow_values_for :email, 'this is not an email address'
end
