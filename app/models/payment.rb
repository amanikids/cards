class Payment < ActiveRecord::Base
  belongs_to :details, :polymorphic => true
end
