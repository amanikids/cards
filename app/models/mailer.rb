class Mailer < ActionMailer::Base
  include ActionView::Helpers::TextHelper

  def new_orders(distributor)
    from ActionMailer::Configuration.from
    recipients "#{distributor.name} <#{distributor.email}>"
    subject "You have #{pluralize distributor.unshipped_order_count, 'new Amani Christmas card order'}."
    body :distributor => distributor
  end

  def order_created(order)
    from ActionMailer::Configuration.from
    recipients "#{order.name} <#{order.email}>"
    subject 'Thank you for your order!'
    body :order => order
  end

  def order_updated(order)
    from ActionMailer::Configuration.from
    recipients "#{order.name} <#{order.email}>"
    subject "We've updated your order."
    body :order => order
  end

  def order_destroyed(order)
    from ActionMailer::Configuration.from
    recipients "#{order.name} <#{order.email}>"
    subject 'Your order has been cancelled.'
    body :order => order
  end

  def shipment_created(order)
    from ActionMailer::Configuration.from
    recipients "#{order.name} <#{order.email}>"
    subject 'Your order has shipped.'
    body :order => order
  end

  def shipment_destroyed(order)
    from ActionMailer::Configuration.from
    recipients "#{order.name} <#{order.email}>"
    subject "Oops! We haven't shipped your order yet."
    body :order => order
  end
end
