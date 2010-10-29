class CreateJustgivingAccounts < ActiveRecord::Migration
  def self.up
    create_table :justgiving_accounts do |t|
      t.string :charity_identifier

      t.timestamps
    end
  end

  def self.down
    drop_table :justgiving_accounts
  end
end
