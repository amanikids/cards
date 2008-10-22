require 'test_helper'

class PaymentTest < ActiveSupport::TestCase
  should_belong_to :order
  should_belong_to :payment_method
  should_belong_to :recipient
end
