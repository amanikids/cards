class OopsDropLocators < ActiveRecord::Migration
  def self.up
    drop_table(:locators) if table_exists?(:locators)
  end

  def self.down
  end
end
