class AddShortNameToProducts < ActiveRecord::Migration
  def self.up
    change_table :products do |t|
      t.string :short_name, :null => false, :default => ''
    end
  end

  def self.down
    change_table :products do |t|
      t.remove :short_name
    end
  end
end
