class CreateVariants < ActiveRecord::Migration
  def self.up
    create_table :variants do |t|
      t.references :sku, :download
      t.string :currency, :default => 'USD'
      t.integer :cents, :position, :default => 0
      t.integer :size, :default => 1
      t.timestamps
    end
  end

  def self.down
    drop_table :variants
  end
end
