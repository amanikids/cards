class CreateLocators < ActiveRecord::Migration
  def self.up
    create_table :locators do |t|
      t.integer :ip_from, :limit => 8
      t.integer :ip_to,   :limit => 8

      t.string :country_code, :limit => 2
      t.string :country_code_with_three_characters, :limit => 3
      t.string :country
    end
  end

  def self.down
    drop_table :locators
  end
end
