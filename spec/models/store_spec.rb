require 'spec_helper'

describe Store do
  it_behaves_like 'a model with translated attributes'

  let 'store' do
    Store.make!
  end

  context 'scopes' do
    it 'loads active Stores' do
      store = Store.make!(:active => true)
      chaff = Store.make!(:active => false)

      Store.active.should include(store)
      Store.active.should_not include(chaff)
    end
  end

  context 'associations' do
    it { should belong_to(:account) }
    it { should have_many(:carts) }
    it { should have_many(:distributors) }
    it { should have_many(:orders) }
    it { should have_many(:products) }
  end

  context 'attributes' do
    it { should allow_mass_assignment_of(:account_type_slash_id) }
    it { should allow_mass_assignment_of(:active) }
    it { should allow_mass_assignment_of(:currency) }
    it { should allow_mass_assignment_of(:description) }
    it { should allow_mass_assignment_of(:distributor_ids) }
    it { should allow_mass_assignment_of(:name) }
    it { should allow_mass_assignment_of(:slug) }
  end

  context 'validations' do
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:slug) }
    it { should validate_presence_of(:currency) }
    it { should validate_presence_of(:description) }

    it { should validate_format_of(:slug).with('us') }
    it { should validate_format_of(:slug).not_with('US').with_message(:invalid) }
    it { should validate_format_of(:slug).not_with('12').with_message(:invalid) }
    it { should validate_format_of(:slug).not_with('usa').with_message(:invalid) }

    it { store; should validate_uniqueness_of(:slug) }
  end

  it 'delegates type_slash_id to account' do
    store.account_type_slash_id.should == store.account.type_slash_id
  end

  it 'uses slug for to_param' do
    store.to_param.should == store.slug
  end
end
