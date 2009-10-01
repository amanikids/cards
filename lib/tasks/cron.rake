desc 'Nightly cron task for Heroku.'
task :cron => :environment do
  today = Date.today.extend(DateInquirer)
  Rake::Task['mailers:unshipped_orders'].invoke if (today.tuesday? || today.friday?)
  Rake::Task['mailers:overdue_batches'].invoke
end
