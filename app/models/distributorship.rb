class Distributorship < ActiveRecord::Base
  belongs_to :store,
    :inverse_of => :distributorships

  belongs_to :user,
    :inverse_of => :distributorships

  attr_accessible :store_id
  attr_accessible :user_id
end
