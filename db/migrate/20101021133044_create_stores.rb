class CreateStores < ActiveRecord::Migration
  def self.up
    create_table :stores do |t|
      t.string :name, :null => false
      t.string :slug, :null => false
      t.string :currency, :null => false
      t.references :distributor, :null => false
      t.references :paypal_account, :null => false
      t.timestamps
    end

    change_table :stores do |t|
      t.index :slug, :unique => true
    end
  end

  def self.down
    change_table :stores do |t|
      t.remove_index :slug
    end

    drop_table :stores
  end
end
