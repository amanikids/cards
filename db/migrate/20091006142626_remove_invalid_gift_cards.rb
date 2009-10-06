class RemoveInvalidGiftCards < ActiveRecord::Migration
  def self.up
    Variant.find_by_name('Art supplies').try(:destroy)
    Variant.find_by_name('Medical Supplies').try(:destroy)
  end

  def self.down
  end
end
