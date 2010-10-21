class CreatePaypalPaymentDetails < ActiveRecord::Migration
  def self.up
    create_table :paypal_payment_details do |t|
      t.string :payer_id, :null => false
      t.string :token, :null => false
      t.timestamps
    end
  end

  def self.down
    drop_table :paypal_payment_details
  end
end
