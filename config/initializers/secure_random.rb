require 'active_support/secure_random'

module ActiveSupport::SecureRandom
  # Base 64 Encoding with URL and Filename Safe Alphabet
  # http://www.apps.ietf.org/rfc/rfc4648.html#sec-5
  def self.base64url(n=nil)
    base64(n).tr('+/=', '-_ ').strip
  end
end
