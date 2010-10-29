require 'spec_helper'

describe PaypalPayment do
  it_behaves_like 'a model with translated attributes'

  context 'attributes' do
    it { should have_readonly_attribute(:payer_id) }
    it { should_not allow_mass_assignment_of(:payer_id) }
    it { should have_readonly_attribute(:token) }
    it { should_not allow_mass_assignment_of(:token) }
  end
end
