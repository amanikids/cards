require File.join(File.dirname(__FILE__), '..', 'test_helper')

class DonationMethodTest < ActiveSupport::TestCase
  should_belong_to :distributor

  context 'paypal named_scope' do
    should 'only return donation methods that have the name "paypal"' do
      expected = Factory.create(:donation_method, :name => 'paypal')
      chaff    = Factory.create(:donation_method, :name => 'not_paypal')

      assert_equal [expected], DonationMethod.paypal
    end
  end
end
