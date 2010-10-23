class CreateUsers < ActiveRecord::Migration
  def self.up
    create_table :users do |t|
      t.string :email,                   :null => false
      t.string :password_hash,           :null => false
      t.string :password_recovery_token, :null => false
      t.timestamps
    end

    change_table :users do |t|
      t.index :email,                   :unique => true
      t.index :password_recovery_token, :unique => true
    end
  end

  def self.down
    change_table :users do |t|
      t.remove_index :email
      t.remove_index :password_recovery_token
    end

    drop_table :users
  end
end
