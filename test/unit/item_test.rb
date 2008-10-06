require 'test_helper'

class ItemTest < ActiveSupport::TestCase
  should_belong_to :card
end
