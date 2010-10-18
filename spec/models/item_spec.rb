require 'spec_helper'

describe Item do
  context 'associations' do
    it { should belong_to(:cart) }
    it { should belong_to(:product) }
  end

  context 'attributes' do
    it { should have_readonly_attribute(:cart_id) }
    it { should_not allow_mass_assignment_of(:cart_id) }
    it { should have_readonly_attribute(:product_id) }
    it { should allow_mass_assignment_of(:product_id) }
    it { should allow_mass_assignment_of(:quantity) }
    it { should have_readonly_attribute(:unit_price) }
    it { should_not allow_mass_assignment_of(:unit_price) }
  end

  context 'validations' do
    it { should validate_numericality_of(:quantity) }
  end

  context 'create' do
    it 'copies the unit price from the product' do
      item = Item.make!(:product => Product.make!(:price => 42))
      item.unit_price.should == 42
    end
  end
end
