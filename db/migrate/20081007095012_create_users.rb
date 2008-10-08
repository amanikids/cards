class CreateUsers < ActiveRecord::Migration
  def self.up
    create_table :users do |t|
      t.string :email
      t.string :encrypted_password, :remember_me_token, :salt, :limit => 40
      t.timestamps
    end
  end

  def self.down
    drop_table :users
  end
end
