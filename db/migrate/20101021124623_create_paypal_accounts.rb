class CreatePaypalAccounts < ActiveRecord::Migration
  def self.up
    create_table :paypal_accounts do |t|
      t.string :login, :null => false
      t.string :password, :null => false
      t.string :signature, :null => false
      t.timestamps
    end
  end

  def self.down
    drop_table :paypal_accounts
  end
end
