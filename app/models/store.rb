class Store < ActiveRecord::Base
  scope :active, where(:active => true)

  belongs_to :account,
    :inverse_of => :store,
    :polymorphic => true

  has_many :carts,
    :inverse_of => :store

  has_many :distributors,
    :inverse_of => :stores,
    :source => :user,
    :through => :distributorships

  has_many :distributorships,
    :inverse_of => :store

  has_many :orders,
    :through => :carts

  has_many :products,
    :inverse_of => :store,
    :order => :created_at

  attr_accessible :account_type_slash_id
  attr_accessible :active
  attr_accessible :currency
  attr_accessible :description
  attr_accessible :distributor_ids
  attr_accessible :name
  attr_accessible :slug

  validates :currency,
    :presence => true
  validates :description,
    :presence => true
  validates :name,
    :presence => true
  validates :slug,
    :format => {
      :allow_blank => true,
      :with        => /\A[a-z][a-z]\z/ },
    :presence => true,
    :uniqueness => true

  delegate :type_slash_id,
    :allow_nil => true,
    :prefix => true,
    :to => :account

  def account_type_slash_id=(account_type_slash_id)
    self.account = Account.find(account_type_slash_id)
  end

  def to_param
    slug
  end
end
