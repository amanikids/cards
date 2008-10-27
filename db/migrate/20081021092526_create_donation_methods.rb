class CreateDonationMethods < ActiveRecord::Migration
  def self.up
    create_table :donation_methods do |t|
      t.string :name, :title, :country
      t.text :description
      t.integer :position
      t.timestamps
    end
  end

  def self.down
    drop_table :donation_methods
  end
end
