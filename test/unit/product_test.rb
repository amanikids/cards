require 'test_helper'

class ProductTest < ActiveSupport::TestCase
  should_require_attributes :name
  should_have_many :variants
end
