class Item < ActiveRecord::Base
  belongs_to :card
  validates_presence_of :card_id, :order_id
end
