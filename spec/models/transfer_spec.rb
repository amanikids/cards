require 'spec_helper'

describe Transfer do
  it_behaves_like 'a model with translated attributes'

  context 'associations' do
    it { should belong_to(:detail) }
    it { should belong_to(:product) }
  end

  context 'attributes' do
    it { should allow_mass_assignment_of(:detail) }
    it { should allow_mass_assignment_of(:happened_at) }
    it { should allow_mass_assignment_of(:quantity) }
    it { should allow_mass_assignment_of(:reason) }
  end

  context 'validations' do
    it { should validate_presence_of(:product_id) }
    it { should validate_presence_of(:happened_at) }
    it { should validate_presence_of(:quantity) }
    it { should validate_numericality_of(:quantity) }
    it { should validate_presence_of(:reason) }
  end
end
