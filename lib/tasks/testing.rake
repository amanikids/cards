begin
  require 'cucumber/rake/task'
  Cucumber::Rake::Task.new(:features) { |t| t.cucumber_opts = '--format pretty --tags ~pending' }
  task :features => 'db:test:prepare'
  task :default => :features
rescue LoadError
  puts "If you'd like to run the features, please install cucumber."
end
