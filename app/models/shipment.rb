class Shipment < ActiveRecord::Base
  belongs_to :order
  belongs_to :shipper, :class_name => 'User'
end
