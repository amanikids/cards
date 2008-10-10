require 'test_helper'

class ItemTest < ActiveSupport::TestCase
  should_belong_to :product, :order
  should_require_attributes :product_id, :order_id
end
