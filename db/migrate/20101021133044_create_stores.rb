class CreateStores < ActiveRecord::Migration
  def self.up
    create_table :stores do |t|
      t.string :name, :null => false
      t.string :slug, :null => false
      t.string :currency, :null => false
      t.references :paypal_account, :null => false
      t.timestamps
    end
  end

  def self.down
    drop_table :stores
  end
end
