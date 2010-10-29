class Packaging < ActiveRecord::Base
  belongs_to :product,
    :inverse_of => :packagings

  attr_accessible :name
  attr_accessible :price
  attr_accessible :size

  validates :name,
    :presence => true,
    :uniqueness => {
      :scope => :product_id }
  validates :price,
    :numericality => {
      :greater_than_or_equal_to => 0,
      :only_integer => true },
    :presence => true
  validates :size,
    :numericality => {
      :greater_than_or_equal_to => 1,
      :only_integer => true },
    :presence => true

  delegate :name,
    :prefix => true,
    :to => :product
end
