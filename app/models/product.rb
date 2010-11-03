class Product < ActiveRecord::Base
  has_many :packagings,
    :inverse_of => :product

  belongs_to :store,
    :inverse_of => :products

  attr_accessible :description
  attr_accessible :image_path
  attr_accessible :name

  validates :description,
    :presence => true
  validates :image_path,
    :presence => true
  validates :name,
    :presence => true,
    :uniqueness => {
      :scope => :store_id }
end
