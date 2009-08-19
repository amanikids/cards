# Be sure to restart your server when you modify this file

# Specifies gem version of Rails to use when vendor/rails is not present
RAILS_GEM_VERSION = '2.3.3' unless defined? RAILS_GEM_VERSION

# Bootstrap the Rails environment, frameworks, and default configuration
require File.join(File.dirname(__FILE__), 'boot')

Rails::Initializer.run do |config|
  # Skip frameworks you're not going to use. To use Rails without a database
  # you must remove the Active Record framework.
  config.frameworks -= [:active_resource]

  # Specify gems that this application depends on.
  # They can then be installed with "rake gems:install" on new installations.
  config.gem 'activemerchant', :lib => 'active_merchant'
  config.gem 'haml'
  config.gem 'matthewtodd-has_digest', :lib => 'has_digest', :source => 'http://gems.github.com'
  config.gem 'money'
  config.gem 'RedCloth', :lib => 'redcloth'

  # Add additional load paths for your own custom dirs
  # config.load_paths += %W( #{RAILS_ROOT}/extras )

  # Make Time.zone default to the specified zone, and make Active Record store time values
  # in the database in UTC, and return them converted to the specified local zone.
  # Run "rake -D time" for a list of tasks for finding time zone names. Comment line to use default local time.
  config.time_zone = 'UTC'

  # Your secret key for verifying cookie session data integrity.
  # If you change this key, all old sessions will become invalid!
  # Make sure the secret is at least 30 characters and all random,
  # no regular words or you'll be exposed to dictionary attacks.
  config.action_controller.session = {
    :session_key => '_cards_amanikids_org_session',
    :secret      => File.read(File.join(Rails.root, 'config', 'secret.txt').strip)
  }

  # Activate observers that should always be running
  config.active_record.observers = :inventory_cache_observer, :notification_observer
end
