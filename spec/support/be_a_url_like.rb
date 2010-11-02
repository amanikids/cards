module RSpec
  module Matchers
    def be_a_url_like(expected)
      BeAUrlLike.new(expected)
    end

    class BeAUrlLike
      def initialize(expected)
        @expected = expected
      end

      def matches?(actual)
        @actual = actual
        uri_hash(@expected) == uri_hash(@actual)
      end

      def failure_message_for_should
        "expected #{@actual} to be a url like #{@expected}"
      end

      private

      def uri_hash(uri)
        uri = URI.parse(uri.to_s)
        {
          :host  => uri.host,
          :path  => uri.path,
          :query => Rack::Utils.parse_query(uri.query)
        }
      end
    end
  end
end
