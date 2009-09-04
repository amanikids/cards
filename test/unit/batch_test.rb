require File.join(File.dirname(__FILE__), '..', 'test_helper')

class BatchTest < ActiveSupport::TestCase
  should_belong_to :distributor
  should_have_many :items

  context 'shipped named scope' do
    should 'only include batches that have been shipped' do
      expected = Factory.create(:batch, :shipped_at => 1.day.ago)
      chaff    = Factory.create(:batch, :shipped_at => nil)

      assert_equal [expected], Batch.shipped
    end
  end

  context 'unshipped named scope' do
    should 'only include batches that have not been shipped' do
      expected = Factory.create(:batch, :shipped_at => nil)
      chaff    = Factory.create(:batch, :shipped_at => 1.day.ago)

      assert_equal [expected], Batch.unshipped
    end
  end

  context '#shipped?' do
    should 'be true iff shipped_at is not nil' do
      assert_equal true,  Factory.build(:batch, :shipped_at => 1.day.ago).shipped?
      assert_equal false, Factory.build(:batch, :shipped_at => nil      ).shipped?
    end
  end

  context '#ship!' do
    should 'set shipped_at to current time' do
      batch = Factory.create(:batch, :shipped_at => nil)
      Factory.create(:item, :batch => batch, :list => Factory.create(:order))
      now = Time.zone.now
      Time.zone.stubs(:now).returns(now)
      batch.ship!
      assert_equal now.to_i, batch.reload.shipped_at.to_i
    end

    should 'not set shipped_at when it has already been set' do
      shipped_at = 1.day.ago
      batch = Factory.create(:batch, :shipped_at => shipped_at)
      batch.ship!
      assert_equal shipped_at.to_i, batch.reload.shipped_at.to_i
    end
  end

  context '#unship!' do
    should 'set shipped_at to nil' do
      batch = Factory.create(:batch, :shipped_at => Time.now)
      Factory.create(:item, :batch => batch, :list => Factory.create(:order))
      batch.unship!
      assert_nil batch.reload.shipped_at
    end
  end

  context '#order' do
    should 'return the order of the first item' do
      order = Factory.build(:order)
      order.items << Factory.build(:item, :list => order)
      order.save!

      batch = order.items.first.batch
      assert_equal order, batch.order
    end
  end

  context '#partial?' do
    should 'return true when there exists another unshipped batch for the order' do
      order = Factory.create(:order)
      2.times do
        order.items << Factory.create(:item,
          :list => order,
          :batch => Factory.create(:batch))
      end

      batch = order.items.first.batch
      assert batch.partial?
    end

    should 'return false if this is the only batch for the order' do
      order = Factory.create(:order)
      order.items << Factory.create(:item,
        :list => order,
        :batch => Factory.create(:batch))

      batch = order.items.first.batch
      assert !batch.partial?
    end

    should 'return false if all other batches in the order have already shipped' do
      order = Factory.create(:order)
      2.times do
        order.items << Factory.create(:item,
          :list => order,
          :batch => Factory.create(:batch))
      end

      batch = order.items.first.batch
      order.items[1].batch.ship!
      assert !batch.partial?
    end
  end

  context '#on_demand?' do
    should 'be true iff distributor is nil' do
      assert Factory.build(:batch, :distributor => nil).on_demand?
      assert !Factory.build(:batch).on_demand?
    end
  end

  context '.deliver_overdue_reminder' do
    should 'send an email iff any Batches are older than 7 days and unshipped' do
      Factory.create(:batch, :shipped_at => nil, :created_at => 6.days.ago)
      assert_no_difference('Mailer.deliveries.count') { Batch.deliver_overdue_reminder }

      batch = Factory.create(:item,
        :list => Factory.create(:order),
        :batch => Factory.create(:batch, :created_at => 8.days.ago)).batch
      assert_difference('Mailer.deliveries.count', 1) { Batch.deliver_overdue_reminder }

      batch.ship!
      assert_no_difference('Mailer.deliveries.count') { Batch.deliver_overdue_reminder }
    end
  end
end
