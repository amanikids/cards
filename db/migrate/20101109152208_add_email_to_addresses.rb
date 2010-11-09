class AddEmailToAddresses < ActiveRecord::Migration
  def self.up
    change_table :addresses do |t|
      t.string :email, :null => false, :default => ''
    end
  end

  def self.down
    change_table :addresses do |t|
      t.remove :email
    end
  end
end
