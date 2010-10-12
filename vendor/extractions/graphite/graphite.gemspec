# -*- encoding: utf-8 -*-
$:.push File.expand_path('../lib', __FILE__)
require 'graphite/version'

Gem::Specification.new do |s|
  s.name        = 'graphite'
  s.version     = Graphite::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ['Matthew Todd']
  s.email       = ['matthew.todd@gmail.com']
  s.homepage    = 'http://github.com/matthewtodd/graphite'
  s.summary     = 'Displays a simple ERD for your Rails 3 application.'
  s.description = 'Reasonably well-behaved?'

  s.rubyforge_project = 'graphite'

  s.requirements = ['dot']
  s.add_development_dependency 'shoe'

  s.files            = Dir['**/*.rdoc', 'lib/**/*.rb', 'man/**/*', 'test/**/*.rb']
  s.test_files       = Dir['test/**/*_test.rb']
  s.extra_rdoc_files = Dir['**/*.rdoc']
  s.require_paths    = ['lib']

  s.rdoc_options = %W(
    --main README.rdoc
    --title #{s.full_name}
    --inline-source
    --webcvs http://github.com/matthewtodd/graphite/blob/v#{s.version}/
  )
end
