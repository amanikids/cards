desc 'Nightly cron task for Heroku.'
task :cron => 'mailers:unshipped_orders'
