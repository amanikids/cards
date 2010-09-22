# It seems like Haml's init.rb isn't being called when we have it vendored as a gem.
Haml.init_rails(binding)

# Tell Haml to wrap html attributes with double instead of single quotes.
Haml::Template.options[:attr_wrapper] = '"'

# The monkey-patched AssetTagHelper in config/initializers is also aware of these paths.
Sass::Plugin.options[:template_location] = Rails.root.join('app', 'stylesheets').to_s
Sass::Plugin.options[:css_location]      = Rails.root.join('tmp', 'stylesheets').to_s
