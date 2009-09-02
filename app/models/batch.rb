class Batch < ActiveRecord::Base
  belongs_to :distributor
  has_many :items
end
