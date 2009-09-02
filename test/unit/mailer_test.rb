require 'test_helper'

class MailerTest < ActionMailer::TestCase
  context 'new_orders' do
    setup { @message = Mailer.create_new_orders(@distributor = Factory(:distributor)) }
    should('be to distributor email') { assert_equal [@distributor.email], @message.to }
    should('be from application email') { assert_equal [Mailer::FROM_ADDRESS], @message.from_addrs.map(&:to_s) }
  end

  context 'order_created' do
    setup { @message = Mailer.create_order_created(@order = Factory(:order)) }
    should('be to email')               { assert_equal [@order.email], @message.to }
    should('be from application email') { assert_equal [Mailer::FROM_ADDRESS], @message.from_addrs.map(&:to_s) }
  end

  context 'order_updated' do
    setup { @message = Mailer.create_order_updated(@order = Factory(:order)) }
    should('be to email')               { assert_equal [@order.email], @message.to }
    should('be from application email') { assert_equal [Mailer::FROM_ADDRESS], @message.from_addrs.map(&:to_s) }
  end

  context 'order_destroyed' do
    setup { @message = Mailer.create_order_destroyed(@order = Factory(:order)) }
    should('be to email')               { assert_equal [@order.email], @message.to }
    should('be from application email') { assert_equal [Mailer::FROM_ADDRESS], @message.from_addrs.map(&:to_s) }
  end

  context 'shipment_created' do
    setup { @message = Mailer.create_shipment_created(@order = Factory(:shipment).order) }
    should('be to email')               { assert_equal [@order.email], @message.to }
    should('be from application email') { assert_equal [Mailer::FROM_ADDRESS], @message.from_addrs.map(&:to_s) }
  end

  context 'shipment_destroyed' do
    setup { @message = Mailer.create_shipment_destroyed(@order = Factory(:shipment).order) }
    should('be to email')               { assert_equal [@order.email], @message.to }
    should('be from application email') { assert_equal [Mailer::FROM_ADDRESS], @message.from_addrs.map(&:to_s) }
  end
end
