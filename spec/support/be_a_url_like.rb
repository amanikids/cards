module RSpec
  module Matchers
    def be_a_url_like(expected)
      BeAUrlLike.new(expected)
    end

    class BeAUrlLike
      def initialize(expected)
        @expected = uri_hash(expected)
      end

      def matches?(actual)
        @actual = uri_hash(actual)
        @expected == @actual
      end

      def failure_message_for_should
        @expected.diff(@actual).map { |k,_| failure_message(k) }.join("\n")
      end

      private

      def failure_message(key)
        return <<-END.gsub(/^ {8}/, '').strip
        #{key.to_s.pluralize} did not match:
            expected: #{@expected[key].inspect}
                 was: #{@actual[key].inspect}
        END
      end

      def uri_hash(uri)
        uri = URI.parse(uri)

        Rack::Utils.parse_query(uri.query).merge(
          :host => uri.host,
          :path => uri.path
        )
      end
    end
  end
end
