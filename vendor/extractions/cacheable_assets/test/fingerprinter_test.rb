require 'test/helper'

class FingerprinterTest < Test::Unit::TestCase
  def setup
    @fingerprinter = Fingerprinter::MD5.new
  end

  def test_returns_an_md5_digest_for_the_given_path
    in_fixtures_path do
      assert_equal '72207595853807422212764151362751546576',
                   @fingerprinter.call('public/javascripts/application.js')
    end
  end
end
