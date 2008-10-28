class CreateDistributorDonationMethods < ActiveRecord::Migration
  def self.up
    create_table :distributor_donation_methods do |t|
      t.references :distributor, :donation_method
      t.integer :position
      t.timestamps
    end
  end

  def self.down
    drop_table :distributor_donation_methods
  end
end
