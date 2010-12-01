class AddOnDemandToProducts < ActiveRecord::Migration
  def self.up
    change_table :products do |t|
      t.boolean :on_demand, :null => false, :default => false
    end
  end

  def self.down
    change_table :products do |t|
      t.remove :on_demand
    end
  end
end
