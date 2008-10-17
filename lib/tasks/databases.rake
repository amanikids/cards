namespace :db do
  desc "Reset migrations, populate, and clone to test."
  task :clean => ['db:migrate:reset', 'db:populate', 'db:test:clone']

  desc "Load real data into the current environment's database."
  task :populate => :environment do
    require 'active_record/fixtures'
    ActiveRecord::Base.establish_connection(RAILS_ENV.to_sym)
    Dir.glob(File.join(RAILS_ROOT, 'db', 'populate', '*.{yml,csv}')).each do |fixture_file|
      Fixtures.create_fixtures('db/populate', File.basename(fixture_file, '.*'))
    end
  end
end
