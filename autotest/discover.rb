Autotest.add_discovery { "rails" }
Autotest.add_discovery { "rspec2" }

Autotest.add_hook(:initialize) do
  class ::Autotest::RailsRspec2
    # Run rspec without using bundle exec.
    # - Unnecessary with rpsec installed in an rvm gemset.
    # - 3-4 seconds faster startup time!
    def using_bundler?
      false
    end
  end
end
