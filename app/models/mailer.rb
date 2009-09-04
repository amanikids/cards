class Mailer < ActionMailer::Base
  include ActionView::Helpers::TextHelper

  FROM_ADDRESS = "Amani Holiday Card Orders <cards@amanikids.org>"

  def new_orders(distributor)
    from FROM_ADDRESS
    recipients "#{distributor.name} <#{distributor.email}>"
    subject "You have #{pluralize distributor.unshipped_batch_count, 'new Amani Christmas card order'}."
    body :distributor => distributor
  end

  def order_created(order)
    from FROM_ADDRESS
    recipients "#{order.name} <#{order.email}>"
    subject 'Thank you for your order!'
    body :order => order
  end

  def order_destroyed(order)
    from FROM_ADDRESS
    recipients "#{order.name} <#{order.email}>"
    subject 'Your order has been cancelled.'
    body :order => order
  end

  def batch_shipped(batch)
    order = batch.order

    from FROM_ADDRESS
    recipients "#{order.name} <#{order.email}>"
    subject 'Your order has shipped.'
    body :batch => batch
  end

  def batch_unshipped(batch)
    order = batch.order

    from FROM_ADDRESS
    recipients "#{order.name} <#{order.email}>"
    subject "Oops! We haven't shipped your order yet."
    body :order => order
  end
end
