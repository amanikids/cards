class CreateAddresses < ActiveRecord::Migration
  def self.up
    create_table :addresses do |t|
      t.references :order
      t.string :name, :email
      t.string :line_one, :line_two, :line_three, :line_four
      t.string :country
      t.timestamps
    end
  end

  def self.down
    drop_table :addresses
  end
end
