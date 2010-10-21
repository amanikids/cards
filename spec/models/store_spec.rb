require 'spec_helper'

describe Store do
  let(:store) { Store.make! }

  context 'attributes' do
    it { should allow_mass_assignment_of(:name) }
    it { should allow_mass_assignment_of(:slug) }
    it { should allow_mass_assignment_of(:currency) }
  end

  context 'validations' do
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:slug) }
    it { should validate_presence_of(:currency) }

    it { should validate_format_of(:slug).with('us') }
    it { should validate_format_of(:slug).not_with('US').with_message(:invalid) }
    it { should validate_format_of(:slug).not_with('12').with_message(:invalid) }
    it { should validate_format_of(:slug).not_with('usa').with_message(:invalid) }

    it { store; should validate_uniqueness_of(:slug) }
  end

  it 'uses slug for to_param' do
    store.to_param.should == store.slug
  end
end
