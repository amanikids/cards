require 'spec_helper'

describe JustgivingPayment do
  let 'justgiving_payment' do
    JustgivingPayment.make!
  end

  context 'validations' do
    it { should validate_presence_of(:donation_identifier) }
    it { justgiving_payment; should validate_uniqueness_of(:donation_identifier) }
  end
end
