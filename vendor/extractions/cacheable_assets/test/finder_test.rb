require 'test/helper'

class FinderTest < Test::Unit::TestCase
  def setup
    @finder = Finder.new('public' => ['/javascripts'])
  end

  def test_returns_nil_full_path_for_unconfigured_sources
    assert_full_path '/favicon.ico', nil
  end

  def test_returns_full_path_for_configured_sources
    assert_full_path '/javascripts/application.js',
                     'public/javascripts/application.js'
  end

  def test_returns_nil_for_configured_but_nonexistent_sources
    assert_full_path '/javascripts/does_not_exist.js', nil
  end

  private

  def assert_full_path(path, expected)
    in_fixtures_path do
      assert_equal expected, @finder.call(path)
    end
  end
end
