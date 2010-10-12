$:.unshift File.expand_path('../lib', __FILE__)
require 'graphite/version'

# Feel free to change whatever you like! This file is yours now.
Gem::Specification.new do |spec|
  spec.name    = 'graphite'
  spec.version = Graphite::VERSION

  spec.summary = 'Graphite is one of my favorite things!'
  spec.description = <<-END.gsub(/^ */, '')
    #{spec.summary}

    Further description here.
  END

  spec.author = 'Matthew Todd'
  spec.email  = 'matthew.todd@gmail.com'
  spec.homepage = 'http://github.com/matthewtodd/graphite'

  # You may find these helpful:
  # spec.requirements = ['git'] # If your library shells out to git
  # spec.required_rubygems_version = ">= 1.3.6" # If you depend on prerelease gems
  # spec.add_runtime_dependency 'nokogiri' # Or what have you
  # spec.add_development_dependency 'cucumber'
  # spec.add_development_dependency 'redgreen'
  # spec.add_development_dependency 'ronn'
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
    --webcvs http://github.com/matthewtodd/graphite/blob/v#{spec.version}/
  )
end
