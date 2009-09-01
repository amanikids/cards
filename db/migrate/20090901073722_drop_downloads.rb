class DropDownloads < ActiveRecord::Migration
  def self.up
    drop_table :downloads

    change_table :variants do |t|
      t.remove :download_id
    end
  end

  def self.down
    # we don't care about preserving the data.
    change_table :variants do |t|
      t.references :download
    end

    create_table :downloads do |t|
      t.string :name, :content_type
      t.timestamps
    end
  end
end
