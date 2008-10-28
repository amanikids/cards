class Inventory < ActiveRecord::Base
  belongs_to :distributor
  belongs_to :sku
end
