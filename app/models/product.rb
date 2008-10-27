class Product < ActiveRecord::Base
  validates_presence_of :name

  belongs_to :image
  has_many :skus
  has_many :variants, :through => :skus, :order => :position, :include => :sku

  named_scope :ordered, :order => :position
end
