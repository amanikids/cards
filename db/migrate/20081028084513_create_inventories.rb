class CreateInventories < ActiveRecord::Migration
  def self.up
    create_table :inventories do |t|
      t.references :distributor, :sku
      t.integer :initial, :promised, :shipped, :default => 0
      t.timestamps
    end
  end

  def self.down
    drop_table :inventories
  end
end
