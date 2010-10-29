require 'spec_helper'

describe JustgivingAccount do
  it_behaves_like 'a model with translated attributes'

  let 'justgiving_account' do
    JustgivingAccount.make!
  end

  context 'associations' do
    it { should have_one(:store) }
  end

  context 'assignment' do
    it { should allow_mass_assignment_of(:charity_identifier) }
  end

  context 'validations' do
    it { should validate_presence_of(:charity_identifier) }
  end
end
