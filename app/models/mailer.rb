class Mailer < ActionMailer::Base
  def order_shipped(order)
    from ActionMailer::Configuration.from
    recipients "#{order.name} <#{order.email}>"
    subject 'Your order has shipped.'
    body :order => order

    order.downloads.each do |download|
      attachment(download.content_type) do |a|
        a.body     = File.read(download.expand_path)
        a.filename = download.name
      end
    end
  end

  def order_thank_you(order)
    from ActionMailer::Configuration.from
    recipients "#{order.name} <#{order.email}>"
    subject 'Thank you for your order!'
    body :order => order
  end
end
