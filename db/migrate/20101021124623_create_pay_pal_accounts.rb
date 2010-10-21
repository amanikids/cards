class CreatePayPalAccounts < ActiveRecord::Migration
  def self.up
    create_table :pay_pal_accounts do |t|
      t.string :login, :null => false
      t.string :password, :null => false
      t.string :signature, :null => false
      t.timestamps
    end
  end

  def self.down
    drop_table :pay_pal_accounts
  end
end
