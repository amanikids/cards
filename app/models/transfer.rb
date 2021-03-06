class Transfer < ActiveRecord::Base
  belongs_to :detail,
    :polymorphic => true

  belongs_to :product,
    :inverse_of => :transfers

  attr_accessible :detail
  attr_accessible :happened_at
  attr_accessible :quantity
  attr_accessible :reason

  validates :detail_id,
    :uniqueness => {
      :allow_blank => true,
      :scope => [:product_id, :detail_type] }
  validates :product_id,
    :presence => true
  validates :happened_at,
    :presence => true
  validates :quantity,
    :numericality => {
      :only_integer => true },
    :presence => true
  validates :reason,
    :presence => true
end
