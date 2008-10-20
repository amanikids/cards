require 'test_helper'

class OrderTest < ActiveSupport::TestCase
  should_eventually 'require_attributes :address'

  should 'not be donor_editable' do
    assert !Order.new.donor_editable?
  end
end
