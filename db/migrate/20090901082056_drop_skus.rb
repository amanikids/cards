class DropSkus < ActiveRecord::Migration
  def self.up
    change_table :inventories do |t|
      t.remove_references :sku
      t.references :product
    end

    change_table :variants do |t|
      t.remove_references :sku
      t.references :product
    end

    drop_table :skus
  end

  def self.down
    create_table :skus do |t|
      t.references :product
      t.string :name
      t.timestamps
    end

    change_table :inventories do |t|
      t.references :sku
      t.remove_references :product
    end

    change_table :variants do |t|
      t.references :sku
      t.remove_references :product
    end
  end
end
