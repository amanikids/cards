require 'test_helper'

class OrderTest < ActiveSupport::TestCase
  should_eventually 'require_attributes :address'

  should 'not be donor_editable' do
    assert !Order.new.donor_editable?
  end

  context 'with an existing order' do
    setup { Factory.create(:order) }
    should_require_unique_attributes :token
  end

  context 'to_param' do
    should 'answer token' do
      order = Factory.build(:order, :token => :token)
      assert_equal :token, order.to_param
    end
  end
end
