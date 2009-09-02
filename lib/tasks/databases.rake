namespace :db do
  desc 'Drops and recreates the database from db/schema.rb for the current environment and loads the seeds.'
  task :reset => [ 'db:drop', 'db:setup' ]

  desc 'Create the database, load the schema, and initialize with the seed data'
  task :setup => ['db:create', 'db:schema:load', 'db:seed']

  desc 'Load the seed data from db/seeds.rb'
  task :seed => :environment do
    seed_file = File.join(RAILS_ROOT, 'db', 'seeds.rb')
    load(seed_file) if File.exist?(seed_file)
  end

  desc 'Populate the DB with sample data'
  task :populate => :environment do
    raise 'Not in production' if Rails.env.production?

    populate_file = File.join(RAILS_ROOT, 'db', 'populate.rb')
    load(populate_file) if File.exist?(populate_file)
  end
end
