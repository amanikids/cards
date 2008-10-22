class Mailer < ActionMailer::Base
  def order_thank_you(order)
    recipients order.email
  end
end
