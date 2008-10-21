class CreatePayments < ActiveRecord::Migration
  def self.up
    create_table :payments do |t|
      t.references :order, :payment_method
      t.datetime :received_at
      t.timestamps
    end
  end

  def self.down
    drop_table :payments
  end
end
