namespace :db do
  desc 'Populate database with real data.'
  task :seed => :environment do
    load(File.join(RAILS_ROOT, 'db', 'seed.rb'))
  end

  desc 'Reset migrations, cloning structure to test, and populate database with sample data.'
  task :refresh => ['db:migrate:reset', 'db:test:clone', 'db:seed']
end
