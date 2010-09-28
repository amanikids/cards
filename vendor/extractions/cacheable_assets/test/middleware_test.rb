require 'test/helper'
require 'rack/test'

class MiddlewareTest < Test::Unit::TestCase
  include Rack::Test::Methods

  def app
    inner_app = proc { |env| [200, {}, 'Hello!'] }
    config    = Configuration.new
    config.static_asset_paths['public'] = ['/javascripts']

    Middleware.new(inner_app, config)
  end

  def test_delegates_unconfigured_paths_to_inner_application
    in_fixtures_path do
      get '/'
      assert_equal 'Hello!', last_response.body
      assert_equal nil, last_response['Cache-Control']
    end
  end

  def test_serves_configured_paths_with_far_future_expiration
    in_fixtures_path do
      get '/javascripts/application-72207595853807422212764151362751546576.js'
      assert_equal '// This is application.js.', last_response.body.strip
      assert_equal 'max-age=31536000, public', last_response['Cache-Control']
    end
  end
end
