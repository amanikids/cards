# Let me hang some parameters here:
ActionMailer::Configuration = Struct.new(:from_name, :from_address, :from).new

# And let me configure them here:
ActionMailer::Configuration.from_name    = 'Amani Holiday Card Orders'
ActionMailer::Configuration.from_address = Rails.env.staging? ? 'orders@cards-preview.amanikids.org' : 'orders@cards.amanikids.org'
ActionMailer::Configuration.from         = "#{ActionMailer::Configuration.from_name} <#{ActionMailer::Configuration.from_address}>"