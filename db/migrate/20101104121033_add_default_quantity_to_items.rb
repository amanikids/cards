class AddDefaultQuantityToItems < ActiveRecord::Migration
  def self.up
    change_table :items do |t|
      t.change_default(:quantity, 1)
    end
  end

  def self.down
    change_table :items do |t|
      t.change_default(:quantity, nil)
    end
  end
end
