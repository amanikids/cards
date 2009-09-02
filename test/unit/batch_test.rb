require 'test_helper'

class BatchTest < ActiveSupport::TestCase
  should_belong_to :distributor
  should_have_many :items
end
