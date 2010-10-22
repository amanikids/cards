class CreateOrders < ActiveRecord::Migration
  def self.up
    create_table :orders do |t|
      t.references :cart, :null => false
      t.references :payment, :null => false, :polymorphic => true
      t.string :token, :null => false
      t.timestamps
    end

    change_table :orders do |t|
      t.index :token, :unique => true
    end
  end

  def self.down
    change_table :orders do |t|
      t.remove_index :token
    end

    drop_table :orders
  end
end
