class Mailer < ActionMailer::Base
  def order_shipped(order)
    from ActionMailer::Configuration.from
    recipients "#{order.name} <#{order.email}>"
    subject 'Your order has shipped.'
    body :order => order
  end

  def order_thank_you(order)
    from ActionMailer::Configuration.from
    recipients "#{order.name} <#{order.email}>"
    subject 'Thank you for your order!'
    body :order => order
  end
end
