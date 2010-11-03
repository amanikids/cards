class AddDescriptionAndImageToProducts < ActiveRecord::Migration
  def self.up
    change_table :products do |t|
      t.text :description, :null => false
      t.string :image_path, :null => false
    end
  end

  def self.down
    change_table :products do |t|
      t.remove :description
      t.remove :image_path
    end
  end
end
