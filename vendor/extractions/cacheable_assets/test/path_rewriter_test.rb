require 'test/helper'

class PathRewriterTest < Test::Unit::TestCase
  def setup
    @config   = mock
    @rewriter = PathRewriter.new(@config)
  end

  def test_does_not_modify_non_configured_paths
    given_config   '/javascripts/application.js', nil
    assert_rewrite '/javascripts/application.js', '/javascripts/application.js'
  end

  def test_inserts_fingerprint_in_configured_paths
    given_config '/javascripts/application.js',
                 'public/javascripts/application.js'

    assert_rewrite '/javascripts/application.js',
                   '/javascripts/application-72207595853807422212764151362751546576.js'
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
