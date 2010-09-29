# Generate stylesheets into tmp. Handy even if you're not on Heroku.
#Sass::Plugin.options[:template_location] = Rails.root.join('app', 'stylesheets').to_s
#Sass::Plugin.options[:css_location]      = Rails.root.join('tmp', 'stylesheets').to_s

# Serve most assets from public, stylesheets from tmp.
#CacheableAssets.configure do |static_asset_paths|
  #static_asset_paths['public'] = %w( /favicon.ico /images /javascripts )
  #static_asset_paths['tmp']    = %w( /stylesheets )
#end
