class DeleteDistributorDonationMethods < ActiveRecord::Migration
  def self.up
    # I'm not trying to preserve the data, as this is all seeded anyway.
    change_table(:donation_methods) do |t|
      t.references :distributor
      t.integer :position
    end

    drop_table :distributor_donation_methods
  end

  def self.down
    # it's certainly possible, but it's also YAGNI, as we'll shortly be starting with a fresh database.
    raise IrreversibleMigration
  end
end
