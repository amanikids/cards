require 'test_helper'

class DistributorDonationMethodTest < ActiveSupport::TestCase
  should_belong_to :distributor
  should_belong_to :donation_method
end
