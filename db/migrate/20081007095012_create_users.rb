class CreateUsers < ActiveRecord::Migration
  def self.up
    create_table :users do |t|
      t.string :name, :email, :type
      t.string :encrypted_password, :salt, :limit => 40
      t.timestamps
    end
  end

  def self.down
    drop_table :users
  end
end
