class Store < ActiveRecord::Base
  belongs_to :paypal_account

  attr_accessible :name
  attr_accessible :slug
  attr_accessible :currency

  validates :name,
    :presence => true
  validates :slug,
    :format => {
      :allow_blank => true,
      :with        => /\A[a-z][a-z]\z/ },
    :presence => true,
    :uniqueness => true
  validates :currency,
    :presence => true

  def to_param
    slug
  end
end
