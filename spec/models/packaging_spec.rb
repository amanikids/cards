require 'spec_helper'

describe Packaging do
  let 'packaging' do
    Packaging.make!
  end

  context 'assignment' do
    it { should allow_mass_assignment_of(:name) }
    it { should allow_mass_assignment_of(:price) }
    it { should allow_mass_assignment_of(:size) }
  end

  context 'associations' do
    it { should belong_to(:product) }
  end

  context 'validations' do
    it { should validate_presence_of(:name) }
    it { packaging; should validate_uniqueness_of(:name).scoped_to(:product_id) }
    it { should validate_presence_of(:price) }
    it { should validate_numericality_of(:price) }
    it { should validate_presence_of(:size) }
    it { should validate_numericality_of(:size) }
  end

  it 'delegates product_name to product' do
    packaging.product_name.should == packaging.product.name
  end
end
