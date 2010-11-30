class CreateTransfers < ActiveRecord::Migration
  def self.up
    create_table :transfers do |t|
      t.references :product, :null => false
      t.references :detail, :polymorphic => true
      t.datetime :happened_at, :null => false
      t.string :reason, :null => false
      t.integer :quantity, :null => false
      t.timestamps
    end

    change_table :transfers do |t|
      t.index :product_id
      t.index :happened_at
    end
  end

  def self.down
    change_table :transfers do |t|
      t.remove_index :product_id
      t.remove_index :happened_at
    end

    drop_table :transfers
  end
end
