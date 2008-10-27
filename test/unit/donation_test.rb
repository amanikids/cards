require 'test_helper'

class DonationTest < ActiveSupport::TestCase
  should_belong_to :order
  should_belong_to :donation_method
  should_belong_to :recipient
end
