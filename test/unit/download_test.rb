require 'test_helper'

class DownloadTest < ActiveSupport::TestCase
  context 'with a Download named NAME' do
    setup { @download = Download.new(:name => 'NAME') }

    should 'expand_path' do
      assert_equal File.join(Rails.root, 'public', 'downloads', 'NAME'), @download.expand_path
    end

    should 'delegate to_param to name' do
      assert_equal 'NAME', @download.to_param
    end
  end
end
