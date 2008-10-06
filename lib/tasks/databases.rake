namespace :db do
  namespace :data do
    desc "Load real data into the current environment's database."
    task :load => :environment do
      require 'active_record/fixtures'
      ActiveRecord::Base.establish_connection(RAILS_ENV.to_sym)
      Dir.glob(File.join(RAILS_ROOT, 'db', 'data', '*.{yml,csv}')).each do |fixture_file|
        Fixtures.create_fixtures('db/data', File.basename(fixture_file, '.*'))
      end
    end
  end
end