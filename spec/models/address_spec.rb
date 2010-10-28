require 'spec_helper'

describe Address do
  context 'assignment' do
    it { should allow_mass_assignment_of(:name) }
    it { should allow_mass_assignment_of(:line_1) }
    it { should allow_mass_assignment_of(:line_2) }
    it { should allow_mass_assignment_of(:line_3) }
    it { should allow_mass_assignment_of(:line_4) }
    it { should allow_mass_assignment_of(:country) }
  end

  context 'validations' do
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:line_1) }
    it { should validate_presence_of(:line_2) }
    it { should validate_presence_of(:country) }
  end
end
