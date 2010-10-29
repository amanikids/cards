class MakeStoreAccountsPolymorphic < ActiveRecord::Migration
  def self.up
    change_table :stores do |t|
      t.remove_references :paypal_account
      t.references :account, :null => false, :polymorphic => true
    end
  end

  def self.down
    change_table :stores do |t|
      t.references :paypal_account, :null => false
      t.remove_references :account
    end
  end
end
