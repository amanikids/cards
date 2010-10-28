class ProductBelongsToStore < ActiveRecord::Migration
  def self.up
    change_table :products do |t|
      t.references :store, :null => false
      t.index :store_id
    end
  end

  def self.down
    change_table :products do |t|
      t.remove_index :store_id
      t.remove_references :store
    end
  end
end
