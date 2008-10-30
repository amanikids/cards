class CreateLists < ActiveRecord::Migration
  def self.up
    create_table :lists do |t|
      t.references :address, :distributor
      t.string :type
      t.string :token, :limit => 40
      t.integer :additional_donation_amount, :default => 0
      t.timestamps
    end
  end

  def self.down
    drop_table :lists
  end
end
