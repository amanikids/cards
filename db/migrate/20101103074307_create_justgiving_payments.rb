class CreateJustgivingPayments < ActiveRecord::Migration
  def self.up
    create_table :justgiving_payments do |t|
      t.string :donation_identifier, :null => false
      t.timestamps
    end

    change_table :justgiving_payments do |t|
      t.index :donation_identifier, :unique => true
    end
  end

  def self.down
    change_table :justgiving_payments do |t|
      t.remove_index :donation_identifier
    end

    drop_table :justgiving_payments
  end
end
