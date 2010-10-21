require 'spec_helper'

describe PaypalPaymentDetails do
  context 'attributes' do
    it { should have_readonly_attribute(:payer_id) }
    it { should allow_mass_assignment_of(:payer_id) }
    it { should have_readonly_attribute(:token) }
    it { should allow_mass_assignment_of(:token) }
  end
end
