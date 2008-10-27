class CreateSkus < ActiveRecord::Migration
  def self.up
    create_table :skus do |t|
      t.references :product
      t.string :name
      t.timestamps
    end
  end

  def self.down
    drop_table :skus
  end
end
