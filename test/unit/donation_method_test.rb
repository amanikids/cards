require 'test_helper'

class DonationMethodTest < ActiveSupport::TestCase
  should_have_named_scope :paypal, :conditions => { :name => 'paypal' }
  should_belong_to :distributor
end
