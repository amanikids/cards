class Address < ActiveRecord::Base
  attr_accessible :name
  attr_accessible :line_1
  attr_accessible :line_2
  attr_accessible :line_3
  attr_accessible :line_4
  attr_accessible :country

  validates :name,    :presence => true
  validates :line_1,  :presence => true
  validates :line_2,  :presence => true
  validates :country, :presence => true
end
