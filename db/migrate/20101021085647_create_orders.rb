class CreateOrders < ActiveRecord::Migration
  def self.up
    create_table :orders do |t|
      t.references :cart, :null => false
      t.references :payment, :null => false
      t.timestamps
    end
  end

  def self.down
    drop_table :orders
  end
end
