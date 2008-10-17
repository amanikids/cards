require 'test_helper'

class OrderTest < ActiveSupport::TestCase
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
