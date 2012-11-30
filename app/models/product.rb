class Product < ActiveRecord::Base
  has_many :packagings,
    :inverse_of => :product,
    :order => 'price DESC'

  belongs_to :store,
    :inverse_of => :products

  has_many :transfers,
    :inverse_of => :product,
    :order => :happened_at

  attr_accessible :description
  attr_accessible :image_path
  attr_accessible :name
  attr_accessible :on_demand

  validates :image_path,
    :presence => true
  validates :name,
    :presence => true,
    :uniqueness => {
      :scope => :store_id }

  def self.available
    (in_stock + on_demand).sort_by(&:created_at)
  end

  def self.in_stock
    joins(:transfers).group(qualified_columns).having('sum(transfers.quantity) > 50')
  end

  def self.on_demand
    where(:on_demand => true)
  end

  def self.qualified_columns
    column_names.map { |column_name| "#{table_name}.#{column_name}" }
  end

  def quantity
    transfers.sum(:quantity)
  end
end
