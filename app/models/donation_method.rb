class DonationMethod < ActiveRecord::Base
  named_scope :for, lambda { |country| { :conditions => ['country = ? OR country IS NULL', country], :order => :position }}

  def to_s
    title
  end
end
