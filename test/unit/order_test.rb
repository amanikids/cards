require 'test_helper'

class OrderTest < ActiveSupport::TestCase
  should_have_one :payment

  should 'not be donor_editable' do
    assert !Order.new.donor_editable?
  end

  context 'an order with an address in SOME COUNTRY' do
    setup { @order = Factory.build(:order, :address => Factory.build(:address, :country => 'SOME COUNTRY')) }

    context 'asking for payment methods' do
      setup { @order.payment_methods }

      before_should 'delegate to PaymentMethod' do
        PaymentMethod.expects(:for).with('SOME COUNTRY')
      end
    end
  end
end
