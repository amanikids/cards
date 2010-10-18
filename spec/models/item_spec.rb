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
      item = Item.make!
      item.unit_price.should == item.product.price
    end
  end

  it 'delegates name to product' do
    item = Item.make!
    item.name.should == item.product.name
  end

  it 'calculates price' do
    item = Item.make!(
      :quantity => 2,
      :product  => Product.make!(:price => 5)
    )
    item.price.should == 10
  end

end
