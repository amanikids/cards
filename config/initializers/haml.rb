# It seems like Haml's init.rb isn't being called when we have it vendored as a gem.
Haml.init_rails(binding)

# Tell Haml to wrap html attributes with double instead of single quotes.
Haml::Template.options[:attr_wrapper] = '"'
