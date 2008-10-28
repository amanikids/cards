class CreateShipments < ActiveRecord::Migration
  def self.up
    create_table :shipments do |t|
      t.references :order
      t.timestamps
    end
  end

  def self.down
    drop_table :shipments
  end
end
