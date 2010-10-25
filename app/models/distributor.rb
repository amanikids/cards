class Distributor < ActiveRecord::Base
  belongs_to :store, :inverse_of => :distributor
  belongs_to :user
end
