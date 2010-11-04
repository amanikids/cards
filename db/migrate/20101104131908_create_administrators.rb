class CreateAdministrators < ActiveRecord::Migration
  def self.up
    create_table :administrators do |t|
      t.references :user, :null => false
      t.timestamps
    end
  end

  def self.down
    drop_table :administrators
  end
end
