require 'test/helper'

class PathRewriterTest < Test::Unit::TestCase
  def setup
    @config   = mock
    @rewriter = PathRewriter.new(@config)
  end

  def test_does_not_modify_non_configured_paths
    given_config   '/favicon.ico', nil
    assert_rewrite '/favicon.ico', '/favicon.ico'
  end

  def test_inserts_fingerprint_in_configured_paths
    given_config '/javascripts/application.js',
                 'public/javascripts/application.js'

    assert_rewrite '/javascripts/application.js',
                   '/javascripts/application-281949768489412648962353822266799178366.js'
  end

  private

  def given_config(source, path)
    @config.expects(:full_path_for).with(source).returns(path)
  end

  def assert_rewrite(path, expected)
    in_fixtures_path do
      assert_equal expected, @rewriter.call(path)
    end
  end
end
