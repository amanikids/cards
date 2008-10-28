class CreateDonationMethods < ActiveRecord::Migration
  def self.up
    create_table :donation_methods do |t|
      t.string :name, :title
      t.text :description
      t.timestamps
    end
  end

  def self.down
    drop_table :donation_methods
  end
end
