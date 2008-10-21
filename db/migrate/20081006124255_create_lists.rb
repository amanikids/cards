class CreateLists < ActiveRecord::Migration
  def self.up
    create_table :lists do |t|
      t.string :type
      t.string :token, :limit => 40
      t.string :payment_method
      t.timestamp :paid_at
      t.timestamps
    end
  end

  def self.down
    drop_table :lists
  end
end
