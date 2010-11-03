class AddDescriptionToStore < ActiveRecord::Migration
  def self.up
    change_table :stores do |t|
      t.text :description, :null => false
    end
  end

  def self.down
    change_table :stores do |t|
      t.remove :description
    end
  end
end
