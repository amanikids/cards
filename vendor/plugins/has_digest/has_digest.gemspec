# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{has_digest}
  s.version = "0.1.3"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Matthew Todd"]
  s.date = %q{2009-09-02}
  s.email = %q{matthew.todd@gmail.com}
  s.extra_rdoc_files = ["README.rdoc", "shoulda_macros/has_digest.rb"]
  s.files = ["Rakefile", "has_digest.gemspec", "README.rdoc", "lib/has_digest.rb", "shoulda_macros/has_digest.rb", "test/has_digest_test.rb", "test/shoulda_macro_test.rb", "test/test_helper.rb"]
  s.rdoc_options = ["--main", "README.rdoc", "--title", "has_digest-0.1.3", "--inline-source"]
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.3.5}
  s.summary = %q{ActiveRecord macro that helps encrypt passwords and generate api tokens before_save.}

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
      s.add_development_dependency(%q<matthewtodd-shoe>, [">= 0"])
      s.add_development_dependency(%q<thoughtbot-shoulda>, [">= 0"])
    else
      s.add_dependency(%q<matthewtodd-shoe>, [">= 0"])
      s.add_dependency(%q<thoughtbot-shoulda>, [">= 0"])
    end
  else
    s.add_dependency(%q<matthewtodd-shoe>, [">= 0"])
    s.add_dependency(%q<thoughtbot-shoulda>, [">= 0"])
  end
end
