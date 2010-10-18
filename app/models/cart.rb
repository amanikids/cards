class Cart < ActiveRecord::Base
  has_many :items
end
