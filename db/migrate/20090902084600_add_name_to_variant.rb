class AddNameToVariant < ActiveRecord::Migration
  def self.up
    change_table :variants do |t|
      t.string :name, :default => '', :null => false
    end
  end

  def self.down
    change_table :variants do |t|
      t.remove :name
    end
  end
end
