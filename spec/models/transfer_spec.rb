require 'spec_helper'

describe Transfer do
  it_behaves_like 'a model with translated attributes'

  context 'associations' do
    it { should belong_to(:detail) }
    it { should belong_to(:product) }
  end

  context 'attributes' do
    it { should allow_mass_assignment_of(:detail) }
    it { should allow_mass_assignment_of(:happened_at) }
    it { should allow_mass_assignment_of(:quantity) }
    it { should allow_mass_assignment_of(:reason) }
  end

  context 'validations' do
    it { should validate_presence_of(:product_id) }
    it { should validate_presence_of(:happened_at) }
    it { should validate_presence_of(:quantity) }
    it { should validate_numericality_of(:quantity) }
    it { should validate_presence_of(:reason) }

    it 'validates uniqueness of detail' do
      item = Item.make!
      transfer = lambda { item.transfer_inventory('REASON') }
      transfer.call
      expect(&transfer).to raise_error(ActiveRecord::RecordInvalid)
    end

    it 'validates uniqueness of detail, ignoring blanks' do
      product = Product.make!
      transfer = lambda { Transfer.make!(:detail => nil, :product => product) }
      transfer.call
      expect(&transfer).to_not raise_error(ActiveRecord::RecordInvalid)
    end

    it 'validates uniqueness of detail, scoped to product' do
      product_one = Product.make!
      Transfer.make!(:detail => product_one, :product => product_one)

      product_two = Product.make!
      expect {
        Transfer.make!(:detail => product_one, :product => product_two)
      }.to_not raise_error(ActiveRecord::RecordInvalid)
    end
  end
end
