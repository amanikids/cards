class CreateVariants < ActiveRecord::Migration
  def self.up
    create_table :variants do |t|
      t.references :product
      t.string :name
      t.integer :price_amount
      t.string :price_currency
      t.timestamps
    end
  end

  def self.down
    drop_table :variants
  end
end
