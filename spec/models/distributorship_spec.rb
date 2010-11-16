require 'spec_helper'

describe Distributorship do
  context 'associations' do
    it { should belong_to(:store) }
    it { should belong_to(:user) }
  end

  context 'attributes' do
    it { should allow_mass_assignment_of(:store_id) }
    it { should allow_mass_assignment_of(:user_id) }
  end
end
