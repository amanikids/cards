class CreateDonations < ActiveRecord::Migration
  def self.up
    create_table :donations do |t|
      t.references :order, :donation_method
      t.datetime :received_at
      t.timestamps
    end
  end

  def self.down
    drop_table :donations
  end
end
