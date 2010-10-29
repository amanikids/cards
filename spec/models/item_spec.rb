require 'spec_helper'

describe Item do
  let 'item' do
    Item.make!
  end

  context 'associations' do
    it { should belong_to(:cart) }
    it { should belong_to(:packaging) }
  end

  context 'attributes' do
    it { should have_readonly_attribute(:cart_id) }
    it { should_not allow_mass_assignment_of(:cart_id) }
    it { should have_readonly_attribute(:packaging_id) }
    it { should allow_mass_assignment_of(:packaging_id) }
    it { should allow_mass_assignment_of(:quantity) }
    it { should have_readonly_attribute(:unit_price) }
    it { should_not allow_mass_assignment_of(:unit_price) }
  end

  context 'validations' do
    it { should validate_numericality_of(:quantity) }
  end

  context 'create' do
    it 'copies the unit price from the packaging' do
      item.unit_price.should == item.packaging.price
    end
  end

  it 'delegates name to packaging' do
    item.name.should == item.packaging.name
  end

  it 'delegates product_name to packaging' do
    item.product_name.should == item.packaging.product_name
  end

  it 'calculates price' do
    item = Item.make!(
      :packaging => Packaging.make!(:price => 5),
      :quantity  => 2
    )
    item.price.should == 10
  end

end
