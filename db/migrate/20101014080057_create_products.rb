class CreateProducts < ActiveRecord::Migration
  def self.up
    create_table :products do |t|
      t.string :name,   :null => false
      t.integer :price, :null => false
      t.timestamps
    end

    change_table :products do |t|
      t.index :name, :unique => true
    end
  end

  def self.down
    change_table :products do |t|
      t.remove_index :name
    end

    drop_table :products
  end
end
