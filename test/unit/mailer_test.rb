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

  context 'order_destroyed' do
    setup { @message = Mailer.create_order_destroyed(@order = Factory(:order)) }
    should('be to email')               { assert_equal [@order.email], @message.to }
    should('be from application email') { assert_equal [Mailer::FROM_ADDRESS], @message.from_addrs.map(&:to_s) }
  end

  context 'batch_shipped' do
    setup do
      @batch = Factory.create(:item, :list => Factory(:order), :batch => Factory(:batch)).batch
      @message = Mailer.create_batch_shipped(@batch)
    end

    should('be to email')               { assert_equal [@batch.order.email], @message.to }
    should('be from application email') do
      assert_equal [Mailer::FROM_ADDRESS], @message.from_addrs.map(&:to_s)
    end
  end

  context 'batch_unshipped' do
    setup do
      @batch = Factory.create(:item, :list => Factory(:order), :batch => Factory(:batch)).batch
      @message = Mailer.create_batch_unshipped(@batch)
    end

    should('be to email')               { assert_equal [@batch.order.email], @message.to }
    should('be from application email') do
      assert_equal [Mailer::FROM_ADDRESS], @message.from_addrs.map(&:to_s)
    end
  end

  context 'overdue_batches' do
    setup do
      @batch   = Factory.create(:batch)
      @message = Mailer.create_overdue_batches([@batch])
    end

    should('be to application email') do
      assert_equal [Mailer::FROM_ADDRESS], @message.to_addrs.map(&:to_s)
    end

    should('be from application email') do
      assert_equal [Mailer::FROM_ADDRESS], @message.from_addrs.map(&:to_s)
    end
  end
end
