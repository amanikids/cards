require File.join(File.dirname(__FILE__), '..', 'test_helper')

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
    setup do
      @batch = Factory.create(:item, :list => Factory(:order), :batch => Factory(:batch)).batch
      @message = Mailer.create_shipment_created(@batch)
    end

    should('be to email')               { assert_equal [@batch.order.email], @message.to }
    should('be from application email') do
      assert_equal [Mailer::FROM_ADDRESS], @message.from_addrs.map(&:to_s)
    end
  end
end
