class AddAccountToDonationMethod < ActiveRecord::Migration
  def self.up
    change_table(:donation_methods) do |t|
      t.string :account
    end
  end

  def self.down
    change_table(:donation_methods) do |t|
      t.remove :account
    end
  end
end
