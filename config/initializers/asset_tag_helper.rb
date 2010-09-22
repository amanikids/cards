# Ensure AssetTagHelper has been loaded before we try to monkey-patch it.
require 'action_view/helpers/asset_tag_helper'

module ActionView::Helpers::AssetTagHelper
  # Insert the asset id in the filename, rather than in the query string. In
  # addition to looking nicer, this also keeps any other static file handlers
  # from preempting our Rack::StaticCache middleware, since these
  # version-numbered files don't actually exist on disk.
  def rewrite_asset_path(source)
    source.insert source.rindex('.'), "-#{rails_asset_id(source)}"
  end

  # Exactly like the original, with calculate_asset_id extracted.
  def rails_asset_id(source)
    if asset_id = ENV["RAILS_ASSET_ID"]
      asset_id
    else
      if @@cache_asset_timestamps && (asset_id = @@asset_timestamps_cache[source])
        asset_id
      else
        asset_id = calculate_asset_id(source)

        if @@cache_asset_timestamps
          @@asset_timestamps_cache_guard.synchronize do
            @@asset_timestamps_cache[source] = asset_id
          end
        end

        asset_id
      end
    end
  end

  private

  # Check out the sass initializer and the Rack::StaticCache setup in
  # environment.rb. We're serving sass-generated stylesheets from tmp.
  def calculate_asset_id(source)
    case source
    when %r{^/stylesheets}
      digest File.join('tmp', source)
    else
      digest File.join('public', source)
    end
  end

  # Prefer digest of file contents over File mtime, since File mtimes change on
  # every Heroku deploy, even if the contents don't.
  #
  # We additionally to_i(16) the digest since Rack::StaticCache assumes version
  # numbers have digits and dots only.
  def digest(path)
    Digest::MD5.file(path).hexdigest.to_i(16).to_s
  end
end
