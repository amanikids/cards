class CreateUsers < ActiveRecord::Migration
  def self.up
    create_table :users do |t|
      t.string :type
      t.string :name, :email, :country
      t.string :encrypted_password, :salt, :limit => 40
      t.string :country_code, :limit => 2
      t.string :currency, :limit => 3
      t.integer :position, :default => 0
      t.timestamps
    end
  end

  def self.down
    drop_table :users
  end
end
