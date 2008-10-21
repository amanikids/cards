require 'test_helper'

class PaymentMethodTest < ActiveSupport::TestCase
  should_have_named_scope 'for(:country)', :conditions => ['country = ? OR country IS NULL', :country], :order => :position
end
