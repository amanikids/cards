class AddShippedAtToOrder < ActiveRecord::Migration
  def self.up
    change_table :orders do |t|
      t.datetime :shipped_at
      t.index :shipped_at
    end
  end

  def self.down
    change_table :orders do |t|
      t.remove_index :shipped_at
      t.remove :shipped_at
    end
  end
end
