class CreateDistributorships < ActiveRecord::Migration
  def self.up
    create_table :distributorships do |t|
      t.references :store, :null => false
      t.references :user, :null => false
      t.timestamps
    end

    change_table :distributorships do |t|
      t.index :store_id
      t.index :user_id
    end

    execute 'INSERT INTO distributorships (store_id, user_id, created_at, updated_at) SELECT id, distributor_id, NOW(), NOW() FROM stores'

    change_table :stores do |t|
      t.remove_references :distributor
    end
  end

  def self.down
    change_table :stores do |t|
      t.references :distributor
    end

    execute 'UPDATE stores SET distributor_id = distributorships.user_id FROM distributorships WHERE stores.id = distributorships.store_id'

    change_table :stores do |t|
      t.change :distributor_id, :integer, :null => false
    end

    change_table :distributorships do |t|
      t.remove_index :store_id
      t.remove_index :user_id
    end

    drop_table :distributorships
  end
end
