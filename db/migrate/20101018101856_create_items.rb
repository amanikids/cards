class CreateItems < ActiveRecord::Migration
  def self.up
    create_table :items do |t|
      t.references :cart,    :null => false
      t.references :product, :null => false
      t.integer :quantity,   :null => false
      t.integer :unit_price, :null => false
      t.timestamps
    end
  end

  def self.down
    drop_table :items
  end
end
