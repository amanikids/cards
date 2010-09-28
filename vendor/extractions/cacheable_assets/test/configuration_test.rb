require 'test/helper'

class ConfigurationTest < Test::Unit::TestCase
  def setup
    @config = Configuration.new
    @config.static_asset_paths['public'] = ['/javascripts']
  end

  def test_returns_nil_full_path_for_unconfigured_sources
    assert_full_path '/favicon.ico', nil
  end

  def test_returns_full_path_for_configured_sources
    assert_full_path '/javascripts/application.js',
                     'public/javascripts/application.js'
  end

  private

  def assert_full_path(path, expected)
    assert_equal expected, @config.full_path_for(path)
  end
end
