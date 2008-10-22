require 'test_helper'

class MailerTest < ActionMailer::TestCase
  context 'order_thank_you' do
    setup { @message = Mailer.create_order_thank_you(@order = Factory.create(:order)) }
    should('be to email')               { assert_equal [@order.email], @message.to }
    should('be from application email') { assert_equal [ActionMailer::Configuration.from_address], @message.from }
  end

  context 'order_shipped' do
    setup { @message = Mailer.create_order_shipped(@order = Factory.create(:shipment).order) }
    should('be to email')               { assert_equal [@order.email], @message.to }
    should('be from application email') { assert_equal [ActionMailer::Configuration.from_address], @message.from }
  end
end
