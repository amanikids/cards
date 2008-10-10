class Item < ActiveRecord::Base
  belongs_to :order
  belongs_to :variant
  validates_presence_of :order_id, :variant_id
end
