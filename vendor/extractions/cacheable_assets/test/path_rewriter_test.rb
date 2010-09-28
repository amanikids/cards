require 'test/helper'

class PathRewriterTest < Test::Unit::TestCase
  def test_does_not_modify_unconfigured_paths
    finder        = proc { |source| nil }
    fingerprinter = proc { |source| '123' }
    rewriter      = PathRewriter.new(finder, fingerprinter)

    assert_equal '/favicon.ico',
                 rewriter.call('/favicon.ico')
  end

  def test_inserts_fingerprint_in_configured_paths
    finder        = proc { |source| "public/#{source}" }
    fingerprinter = proc { |source| '123' }
    rewriter      = PathRewriter.new(finder, fingerprinter)

    assert_equal '/javascripts/application-123.js',
                 rewriter.call('/javascripts/application.js')
  end
end
