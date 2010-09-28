# Heroku's Rack stack includes a Heroku::StaticAssetsMiddleware that (at least
# as of 2010-06-25) blows away any Cache-Control header coming from a
# Rack::File. This would defeat the purpose of our Rack::StaticCache middleware
# setup (see config/environment.rb), so we monkey-patch it here to do nothing.
module Heroku
  class StaticAssetsMiddleware
    def initialize(app)
      @app = app
    end

    def call(env)
      @app.call(env)
    end
  end
end
