require File.join(File.dirname(__FILE__), 'test_helper')

class ShouldaMacroTest < Test::Unit::TestCase
  def self.described_type
    model_with_attributes(:token) do
      has_digest :token
    end
  end

  # This is just a smoke test to make sure we can call should_have_digest.
  should_have_digest :token
end