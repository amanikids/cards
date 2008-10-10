class Item < ActiveRecord::Base
  belongs_to :product
  belongs_to :order
  validates_presence_of :order_id, :product_id
end
