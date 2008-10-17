# Configure ActiveMerchant in test mode, unless we're running in production.
ActiveMerchant::Billing::Base.mode = Rails.env.production? ? :production : :test
