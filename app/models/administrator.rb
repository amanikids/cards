class Administrator < ActiveRecord::Base
  belongs_to :user,
    :inverse_of => :administrator
end
