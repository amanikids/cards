class CreateProducts < ActiveRecord::Migration
  def self.up
    create_table :products do |t|
      t.references :image
      t.string :name
      t.text :description
      t.integer :position
      t.timestamps
    end
  end

  def self.down
    drop_table :products
  end
end
