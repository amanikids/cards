class DeleteImages < ActiveRecord::Migration
  def self.up
    # I'm not trying to preserve the data, as this is all seeded anyway.
    change_table :products do |t|
      t.remove :image_id
      t.string :image_path
    end

    drop_table :images
  end

  def self.down
    # it's certainly possible, but it's also YAGNI, as we'll shortly be starting with a fresh database.
    raise IrreversibleMigration
  end
end
