require 'test_helper'

class MoneyTest < ActiveSupport::TestCase
  TEN_DOLLARS  = Money.new(10, 'USD')
  FIVE_DOLLARS = Money.new(5, 'USD')

  context 'addition' do
    should 'should work for like currencies' do
      assert_equal TEN_DOLLARS, FIVE_DOLLARS + FIVE_DOLLARS
    end
  end

  should 'be able to multiply monies' do
    assert_equal TEN_DOLLARS, FIVE_DOLLARS * 2
  end
end
