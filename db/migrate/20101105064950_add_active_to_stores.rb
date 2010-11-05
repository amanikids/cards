class AddActiveToStores < ActiveRecord::Migration
  def self.up
    change_table :stores do |t|
      t.boolean :active, :null => false, :default => false
      t.index :active
    end
  end

  def self.down
    change_table :stores do |t|
      t.remove_index :active
      t.remove :active
    end
  end
end
