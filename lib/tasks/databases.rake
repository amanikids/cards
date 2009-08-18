namespace :db do
  desc 'Populate database with real data.'
  task :seed => :environment do
    load(File.join(RAILS_ROOT, 'db', 'seed.rb'))
  end

  desc 'Reset and seed the database, cloning structure to test.'
  task :refresh => ['db:migrate:reset', 'db:test:clone', 'db:seed']
end
