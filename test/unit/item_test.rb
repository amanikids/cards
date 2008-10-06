require 'test_helper'

class ItemTest < ActiveSupport::TestCase
  should_belong_to :card
  should_require_attributes :card_id, :order_id
end
