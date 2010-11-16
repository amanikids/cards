class RenameToAdministratorships < ActiveRecord::Migration
  def self.up
    rename_table :administrators, :administratorships
  end

  def self.down
    rename_table :administratorships, :administrators
  end
end
