require 'test_helper'

class NotificationObserverTest < ActiveSupport::TestCase
  subject { NotificationObserver.instance }
  should_observe :order, :batch

  context 'with an existing Order' do
    setup { @order = Factory.create(:order) }

    context 'after_create' do
      setup { subject.after_create(@order) }
      before_should('deliver notification') { Mailer.expects(:deliver_order_created).with(@order) }
      should('return not return false') { assert_not_equal false, @result }
    end

    context 'before_destroy' do
      setup { @result = subject.before_destroy(@order) }
      before_should('deliver notification') { Mailer.expects(:deliver_order_destroyed).with(@order) }
      should('return not return false') { assert_not_equal false, @result }
    end
  end

  context 'with an existing Batch' do
    setup { @batch = Factory.create(:batch) }

    context 'after_update' do
      context 'shipped' do
        setup do
          Mailer.stubs(:deliver_batch_shipped)
          @batch.stubs(:shipped_at_changed?).returns(true)
          @batch.stubs(:shipped_at).returns(Time.zone.now)
        end

        should 'deliver notification' do
          Mailer.expects(:deliver_batch_shipped).with(@batch)
          subject.after_update(@batch)
        end

        should('return not return false') do
          assert_not_equal false, subject.after_update(@batch)
        end
      end

      context 'unshipped' do
        setup do
          Mailer.stubs(:deliver_batch_unshipped)
          @batch.stubs(:shipped_at_changed?).returns(true)
          @batch.stubs(:shipped_at).returns(nil)
        end

        should 'deliver notification' do
          Mailer.expects(:deliver_batch_unshipped).with(@batch)
          subject.after_update(@batch)
        end

        should('return not return false') do
          assert_not_equal false, subject.after_update(@batch)
        end
      end
    end
  end
end
