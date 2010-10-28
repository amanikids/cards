class Product < ActiveRecord::Base
  belongs_to :store,
    :inverse_of => :products

  attr_accessible :name
  attr_accessible :price

  validates :name,
    :presence => true,
    :uniqueness => true
  validates :price,
    :presence => true,
    :numericality => {
      :greater_than_or_equal_to => 0,
      :only_integer => true }
end
