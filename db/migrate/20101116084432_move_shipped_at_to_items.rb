class MoveShippedAtToItems < ActiveRecord::Migration
  def self.up
    change_table :items do |t|
      t.datetime :shipped_at
      t.index :shipped_at
    end

    execute 'UPDATE items SET shipped_at = orders.shipped_at FROM orders WHERE items.cart_id = orders.cart_id'

    change_table :orders do |t|
      t.remove_index :shipped_at
      t.remove :shipped_at
    end
  end

  def self.down
    change_table :orders do |t|
      t.datetime :shipped_at
      t.index :shipped_at
    end

    execute 'UPDATE orders SET shipped_at = items.shipped_at FROM items WHERE items.cart_id = orders.cart_id'

    change_table :items do |t|
      t.remove :shipped_at
      t.remove_index :shipped_at
    end
  end
end
