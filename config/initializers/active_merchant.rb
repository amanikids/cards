# Configure ActiveMerchant in test mode, unless we're running in production.
ActiveMerchant::Billing::Base.mode = Rails.env.production? ? :production : :test

# Include the view helper.
require 'active_merchant/billing/integrations/action_view_helper'
ActionView::Base.send(:include, ActiveMerchant::Billing::Integrations::ActionViewHelper)
