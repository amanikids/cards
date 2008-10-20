require 'test_helper'

class OrderTest < ActiveSupport::TestCase
  should_eventually 'require_attributes :address'

  should 'not be donor_editable' do
    assert !Order.new.donor_editable?
  end

  context 'to_param' do
    should 'answer token' do
      order = Factory.build(:order, :token => :token)
      assert_equal :token, order.to_param
    end
  end
end
