class CreateItems < ActiveRecord::Migration
  def self.up
    create_table :items do |t|
      t.references :list, :variant
      t.integer :quantity, :default => 1
      t.timestamps
    end
  end

  def self.down
    drop_table :items
  end
end
