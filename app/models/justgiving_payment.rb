class JustgivingPayment < ActiveRecord::Base
  validates :donation_identifier,
    :presence => true,
    :uniqueness => true
end
