class CreatePayPalPaymentDetails < ActiveRecord::Migration
  def self.up
    create_table :pay_pal_payment_details do |t|
      t.string :payer_id, :null => false
      t.string :token, :null => false
      t.timestamps
    end
  end

  def self.down
    drop_table :pay_pal_payment_details
  end
end
