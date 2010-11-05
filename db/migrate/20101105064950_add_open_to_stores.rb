class AddOpenToStores < ActiveRecord::Migration
  def self.up
    change_table :stores do |t|
      t.boolean :open, :null => false, :default => false
      t.index :open
    end
  end

  def self.down
    change_table :stores do |t|
      t.remove_index :open
      t.remove :open
    end
  end
end
