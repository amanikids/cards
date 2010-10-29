class ScopeProductNameUniquenessToStoreId < ActiveRecord::Migration
  def self.up
    change_table :products do |t|
      t.remove_index :name
      t.index [:store_id, :name], :unique => true
    end
  end

  def self.down
    change_table :products do |t|
      t.remove_index [:store_id, :name]
      t.index :name, :unique => true
    end
  end
end
