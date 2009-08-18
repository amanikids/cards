# Let me hang some parameters here:
ActiveMerchant::Configuration = Struct.new(:override_paypal_account).new

# Configure ActiveMerchant in test mode, unless we're running in production.
if Rails.env.production?
  ActiveMerchant::Billing::Base.mode = :production
  ActiveMerchant::Configuration.override_paypal_account = nil
else
  ActiveMerchant::Billing::Base.mode = :test
  ActiveMerchant::Configuration.override_paypal_account = 'develo_1224327392_biz@matthewtodd.org'
end

# Include the ActiveMerchant view helper.
require 'active_merchant/billing/integrations/action_view_helper'
ActionView::Base.send(:include, ActiveMerchant::Billing::Integrations::ActionViewHelper)
