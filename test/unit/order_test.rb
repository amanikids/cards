require 'test_helper'

class OrderTest < ActiveSupport::TestCase
  should_have_many :items
end
