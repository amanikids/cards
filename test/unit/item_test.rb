require 'test_helper'

class ItemTest < ActiveSupport::TestCase
  should_belong_to :order, :variant
  should_require_attributes :order_id, :variant_id
end
