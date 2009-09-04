namespace :mailers do
  desc 'Sends a reminder email to all Distributors with unshipped Orders.'
  task :unshipped_orders => :environment do
    Distributor.deliver_new_order_reminders
  end

  desc 'Sends a reminder email to all Distributors with unshipped Orders.'
  task :overdue_batches => :environment do
    Batch.deliver_overdue_reminder
  end
end