class AddIndicesForPosition < ActiveRecord::Migration
  TABLES = %w(products variants users)

  def self.up
    TABLES.each do |table|
      add_index table, :position
    end
  end

  def self.down
    TABLES.each do |table|
      drop_index table, :position
    end
  end
end
