class CreateBatches < ActiveRecord::Migration
  def self.up
    create_table :batches do |t|
      t.references :distributor
      t.timestamp :shipped_at
      t.timestamps
    end

    change_table :items do |t|
      t.references :batch
    end
  end

  def self.down
    change_table :items do |t|
      t.remove_references :batch
    end

    drop_table :batches
  end
end
