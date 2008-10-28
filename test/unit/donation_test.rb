require 'test_helper'

class DonationTest < ActiveSupport::TestCase
  should_belong_to :order
  should_belong_to :donation_method
end
