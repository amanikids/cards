class ItemBelongsToPackaging < ActiveRecord::Migration
  def self.up
    change_table :items do |t|
      t.remove_references :product
      t.references :packaging, :null => false
    end
  end

  def self.down
    change_table :items do |t|
      t.remove_references :packaging
      t.references :product, :null => false
    end
  end
end
