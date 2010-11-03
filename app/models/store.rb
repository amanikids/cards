class Store < ActiveRecord::Base
  belongs_to :account,
    :inverse_of => :store,
    :polymorphic => true

  has_many :carts,
    :inverse_of => :store

  belongs_to :distributor,
    :class_name => 'User',
    :inverse_of => :stores

  has_many :orders,
    :through => :carts

  has_many :products,
    :inverse_of => :store

  attr_accessible :currency
  attr_accessible :description
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

  def to_param
    slug
  end
end
