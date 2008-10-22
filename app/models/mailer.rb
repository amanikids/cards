class Mailer < ActionMailer::Base
  def order_thank_you(order)
    from ActionMailer::Configuration.from
    recipients "#{order.name} <#{order.email}>"
    subject 'Thank you for your order!'
    body :order => order
  end
end
