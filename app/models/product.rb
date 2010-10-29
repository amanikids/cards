class Product < ActiveRecord::Base
  has_many :packagings,
    :inverse_of => :product

  belongs_to :store,
    :inverse_of => :products

  attr_accessible :name

  validates :name,
    :presence => true,
    :uniqueness => true
end
