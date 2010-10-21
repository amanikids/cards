require 'spec_helper'

describe PaypalAccount do
  context 'assignment' do
    it { should allow_mass_assignment_of(:login) }
    it { should allow_mass_assignment_of(:password) }
    it { should allow_mass_assignment_of(:signature) }
  end

  context 'validations' do
    it { should validate_presence_of(:login) }
    it { should validate_presence_of(:password) }
    it { should validate_presence_of(:signature) }
  end
end
