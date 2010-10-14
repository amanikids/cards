require 'spec_helper'

describe Product do
  context 'assignment' do
    it { should allow_mass_assignment_of(:name) }
    it { should allow_mass_assignment_of(:price) }
  end

  context 'validations' do
    before { Product.make! }
    it { should validate_presence_of(:name) }
    it { should validate_uniqueness_of(:name) }
    it { should validate_presence_of(:price) }
    it { should validate_numericality_of(:price) }
  end
end
