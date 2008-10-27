require 'test_helper'

class ProductTest < ActiveSupport::TestCase
  should_require_attributes :name
  should_belong_to :image
  should_have_many :skus
  should_have_many :variants, :through => :skus
  should_have_named_scope :ordered, :order => :position
end
