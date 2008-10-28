class Product < ActiveRecord::Base
  validates_presence_of :name

  belongs_to :image
  has_many :skus
  has_many :variants, :through => :skus, :order => :position, :include => :sku

  named_scope :ordered, :order => :position

  def available?(distributor)
    available_variants(distributor).any?
  end

  def available_variants(distributor)
    variants.select { |variant| variant.available?(distributor) }
  end
end
