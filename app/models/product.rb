class Product < ActiveRecord::Base
  validates_presence_of :name
  has_many :variants, :order => :position
  named_scope :ordered, :order => :position
end
