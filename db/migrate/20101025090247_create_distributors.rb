class CreateDistributors < ActiveRecord::Migration
  def self.up
    create_table :distributors do |t|
      t.references :store, :null => false
      t.references :user, :null => false
      t.timestamps
    end

    change_table :distributors do |t|
      t.index :store_id
      t.index :user_id
    end
  end

  def self.down
    change_table :distributors do |t|
      t.remove_index :store_id
      t.remove_index :user_id
    end

    drop_table :distributors
  end
end
