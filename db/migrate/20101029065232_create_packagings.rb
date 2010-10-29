class CreatePackagings < ActiveRecord::Migration
  def self.up
    create_table :packagings do |t|
      t.references :product, :null => false
      t.string :name, :null => false
      t.integer :size, :null => false
      t.integer :price, :null => false
      t.timestamps
    end

    change_table :packagings do |t|
      t.index :product_id
    end
  end

  def self.down
    change_table :packagings do |t|
      t.remove_index :product_id
    end

    drop_table :packagings
  end
end
