$:.unshift File.expand_path('../lib', __FILE__)
require 'cacheable_assets/version'

# Feel free to change whatever you like! This file is yours now.
Gem::Specification.new do |spec|
  spec.name    = 'cacheable_assets'
  spec.version = CacheableAssets::VERSION

  spec.summary = 'CacheableAssets is one of my favorite things!'
  spec.description = <<-END.gsub(/^ */, '')
    #{spec.summary}

    Further description here.
  END

  spec.author = 'Matthew Todd'
  spec.email  = 'matthew.todd@gmail.com'
  spec.homepage = 'http://github.com/matthewtodd/cacheable_assets'

  spec.add_runtime_dependency 'rack-contrib'
  spec.add_development_dependency 'shoe'

  # The kooky &File.method(:basename) trick keeps us from accidentally
  # shadowing a variable named "file" in the context that evaluates this
  # gemspec. I actually ran into this problem with Bundler!
  spec.files            = Dir['**/*.rdoc', 'bin/*', 'data/**/*', 'ext/**/*.{rb,c}', 'lib/**/*.rb', 'man/**/*', 'test/**/*.rb']
  spec.executables      = Dir['bin/*'].map &File.method(:basename)
  spec.extensions       = Dir['ext/**/extconf.rb']
  spec.extra_rdoc_files = Dir['**/*.rdoc', 'ext/**/*.c']
  spec.test_files       = Dir['test/**/*_test.rb']

  spec.rdoc_options = %W(
    --main README.rdoc
    --title #{spec.full_name}
    --inline-source
    --webcvs http://github.com/matthewtodd/cacheable_assets/blob/v#{spec.version}/
  )
end
