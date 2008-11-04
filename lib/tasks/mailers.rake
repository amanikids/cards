namespace :mailers do
  desc 'Sends a reminder email to all Distributors with unshipped Orders.'
  task :unshipped_orders => :environment do
    Distributor.all.each do |distributor|
      Mailer.deliver_new_orders(distributor) unless distributor.unshipped_order_count.zero?
    end
  end
end