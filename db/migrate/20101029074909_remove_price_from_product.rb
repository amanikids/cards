class RemovePriceFromProduct < ActiveRecord::Migration
  def self.up
    change_table :products do |t|
      t.remove :price
    end
  end

  def self.down
    change_table :products do |t|
      t.integer :price, :null => false
    end
  end
end
