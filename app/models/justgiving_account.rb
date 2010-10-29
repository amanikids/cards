class JustgivingAccount < ActiveRecord::Base
  has_one :store,
    :as => :account,
    :inverse_of => :account

  attr_accessible :charity_identifier

  validates :charity_identifier,
    :presence => true
end
