class CartsBelongToStores < ActiveRecord::Migration
  def self.up
    change_table :carts do |t|
      t.references :store, :null => false
      t.index :store_id
    end

    change_table :orders do |t|
      t.remove_index :store_id
      t.remove_references :store
    end
  end

  def self.down
    change_table :orders do |t|
      t.references :store, :null => false
      t.index :store_id
    end

    change_table :carts do |t|
      t.remove_index :store_id
      t.remove_references :store
    end
  end
end
