require 'test/unit'
require 'mocha'
require 'cacheable_assets'

class Test::Unit::TestCase
  include CacheableAssets

  private

  def in_fixtures_path(&block)
    Dir.chdir('test/fixtures', &block)
  end
end
