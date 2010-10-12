# -*- encoding: utf-8 -*-
$:.push File.expand_path('../lib', __FILE__)
require 'cacheable_assets/version'

Gem::Specification.new do |s|
  s.name        = 'cacheable_assets'
  s.version     = CacheableAssets::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ['Matthew Todd']
  s.email       = ['matthew.todd@gmail.com']
  s.homepage    = 'http://github.com/matthewtodd/cacheable_assets'
  s.summary     = "Drop-in improvements for Rails 3's static asset serving."
  s.description = "Adds Rack::StaticCache middleware and writes MD5 fingerprints into asset ids."

  s.rubyforge_project = 'cacheable_assets'

  s.add_runtime_dependency 'rack-contrib'
  s.add_development_dependency 'shoe'
  s.add_development_dependency 'rack-test'

  s.files            = Dir['**/*.rdoc', 'lib/**/*.rb', 'man/**/*', 'test/**/*.rb']
  s.test_files       = Dir['test/**/*_test.rb']
  s.extra_rdoc_files = Dir['**/*.rdoc']
  s.require_paths    = ['lib']

  s.rdoc_options = %W(
    --main README.rdoc
    --title #{s.full_name}
    --inline-source
    --webcvs http://github.com/matthewtodd/cacheable_assets/blob/v#{s.version}/
  )
end
