class CreateVariants < ActiveRecord::Migration
  def self.up
    create_table :variants do |t|
      t.references :product
      t.string :name
      t.timestamps
    end
  end

  def self.down
    drop_table :variants
  end
end
