require 'test_helper'

class DownloadTest < ActiveSupport::TestCase
  should 'delegate to_param to name' do
    assert_equal 'NAME', Download.new(:name => 'NAME').to_param
  end
end
