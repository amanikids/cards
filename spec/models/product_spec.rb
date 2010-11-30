require 'spec_helper'

describe Product do
  it_behaves_like 'a model with translated attributes'

  context 'associations' do
    it { should have_many(:packagings) }
    it { should belong_to(:store) }
    it { should have_many(:transfers) }
  end

  context 'assignment' do
    it { should allow_mass_assignment_of(:description) }
    it { should allow_mass_assignment_of(:image_path) }
    it { should allow_mass_assignment_of(:name) }
  end

  context 'validations' do
    before { Product.make! }
    it { should validate_presence_of(:description) }
    it { should validate_presence_of(:image_path) }
    it { should validate_presence_of(:name) }
    it { should validate_uniqueness_of(:name).scoped_to(:store_id) }
  end

  context '#quantity' do
    it 'is the sum of the transfers' do
      product = Product.make!
      2.times { Transfer.make!(:product => product, :quantity => 21) }
      product.quantity.should == 42
    end
  end
end
