class Store < ActiveRecord::Base
  has_many :carts,
    :inverse_of => :store

  belongs_to :distributor,
    :class_name => 'User',
    :inverse_of => :stores

  has_many :orders,
    :through => :carts

  belongs_to :paypal_account

  attr_accessible :currency
  attr_accessible :name
  attr_accessible :slug

  validates :currency,
    :presence => true
  validates :name,
    :presence => true
  validates :slug,
    :format => {
      :allow_blank => true,
      :with        => /\A[a-z][a-z]\z/ },
    :presence => true,
    :uniqueness => true

  def products
    Product.all
  end

  def to_param
    slug
  end
end
