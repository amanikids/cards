require 'test_helper'

class MailerTest < ActionMailer::TestCase
  context 'order_thank_you' do
    setup { @message = Mailer.create_order_thank_you(@order = Factory.create(:order)) }
    should('be to email') { assert_equal [@order.email], @message.to }
    should('be from email') { assert_equal [@order.email], @message.to }
  end
end
