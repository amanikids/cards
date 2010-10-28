class AddAddressToOrders < ActiveRecord::Migration
  def self.up
    change_table :orders do |t|
      t.references :address, :null => false
    end
  end

  def self.down
    change_table :orders do |t|
      t.remove_references :address
    end
  end
end
