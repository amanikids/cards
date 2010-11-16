class Administratorship < ActiveRecord::Base
  belongs_to :user,
    :inverse_of => :administratorship
end
