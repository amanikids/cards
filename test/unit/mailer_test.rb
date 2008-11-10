require 'test_helper'

class MailerTest < ActionMailer::TestCase
  context 'new_orders' do
    setup { @message = Mailer.create_new_orders(@distributor = Factory(:distributor)) }
    should('be to distributor email') { assert_equal [@distributor.email], @message.to }
    should('be from application email') { assert_equal [ActionMailer::Configuration.from_address], @message.from }
  end

  context 'order_created' do
    setup { @message = Mailer.create_order_created(@order = Factory(:order)) }
    should('be to email')               { assert_equal [@order.email], @message.to }
    should('be from application email') { assert_equal [ActionMailer::Configuration.from_address], @message.from }
  end

  context 'order_destroyed' do
    setup { @message = Mailer.create_order_destroyed(@order = Factory(:order)) }
    should('be to email')               { assert_equal [@order.email], @message.to }
    should('be from application email') { assert_equal [ActionMailer::Configuration.from_address], @message.from }
  end

  context 'shipment_created' do
    setup { @message = Mailer.create_shipment_created(@order = Factory(:shipment).order) }
    should('be to email')               { assert_equal [@order.email], @message.to }
    should('be from application email') { assert_equal [ActionMailer::Configuration.from_address], @message.from }
  end

  context 'shipment_created with downloads' do
    setup do
      @order = Factory(:shipment).order
      @order.items << Factory(:downloadable_item)
      @message = Mailer.create_shipment_created(@order)
    end

    should 'have 2 parts' do
      assert_equal 2, @message.parts.size
    end

    context 'attachment' do
      setup do
        @download   = @order.items.first.download
        @attachment = @message.parts.last
      end

      should 'have the right content type' do
        assert_equal @download.content_type, @attachment.content_type
      end
    end
  end

  context 'shipment_destroyed' do
    setup { @message = Mailer.create_shipment_destroyed(@order = Factory(:shipment).order) }
    should('be to email')               { assert_equal [@order.email], @message.to }
    should('be from application email') { assert_equal [ActionMailer::Configuration.from_address], @message.from }
  end
end
