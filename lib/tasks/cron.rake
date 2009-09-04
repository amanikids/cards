desc 'Nightly cron task for Heroku.'
task :cron => :environment do
  def today_is?(*args)
    args.collect {|x| Date::DAYNAMES.index(x) }.include?(Date.today.wday)
  end

  Rake::Task['mailers:unshipped_orders'].invoke if today_is?('Tuesday', 'Friday')
  Rake::Task['mailers:overdue_batches'].invoke
end
