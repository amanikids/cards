namespace :db do
  desc 'Populate the DB with sample data'
  task :populate => :environment do
    raise 'Not in production' if Rails.env.production?

    populate_file = File.join(RAILS_ROOT, 'db', 'populate.rb')
    load(populate_file) if File.exist?(populate_file)
  end
end
