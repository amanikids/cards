Autotest.add_discovery { "rails" }
Autotest.add_discovery { "rspec2" }

Autotest.add_hook(:initialize) do |at|
  # Run autotest -v to see what files are triggering a re-run.
  %w( .bundle .git .rvmrc .screenrc README Rakefile TODO autotest lib/tasks vendor ).each do |exception|
    at.add_exception(/^([\.\/]*)?#{Regexp.escape(exception)}/)
  end

  # Run rspec without using bundle exec:
  # - Unnecessary with rpsec installed in an rvm gemset.
  # - 3-4 seconds faster startup time!
  def at.using_bundler?
    false
  end
end

# Cucumber's AutotestMixin looks for $q, but the latest autotest gem sets
# options[:quiet] instead.
$q = Autotest.options[:quiet]
