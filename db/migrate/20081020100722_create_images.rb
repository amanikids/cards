class CreateImages < ActiveRecord::Migration
  def self.up
    create_table :images do |t|
      t.string :path
      t.integer :width, :height
      t.timestamps
    end
  end

  def self.down
    drop_table :images
  end
end
