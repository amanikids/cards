class CreateAddresses < ActiveRecord::Migration
  def self.up
    create_table :addresses do |t|
      t.string :name, :null => false
      t.string :line_1, :null => false
      t.string :line_2, :null => false
      t.string :line_3
      t.string :line_4
      t.string :country, :null => false
      t.timestamps
    end
  end

  def self.down
    drop_table :addresses
  end
end
