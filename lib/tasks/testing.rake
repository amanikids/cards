begin
  require 'cucumber/rake/task'
  Cucumber::Rake::Task.new(:features) { |t| t.cucumber_opts = '--format pretty --tags ~pending' }
  task :features => 'db:test:prepare'
  #remove_task :default
  #task :default => ['test:units', 'features']
rescue LoadError
  puts "If you'd like to run the features, please install cucumber."
end
