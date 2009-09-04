class RemoveShipmentModel < ActiveRecord::Migration
  def self.up
    drop_table :shipments
  end

  def self.down
    create_table "shipments", :force => true do |t|
      t.integer  "order_id"
      t.datetime "created_at"
      t.datetime "updated_at"
    end
  end
end
