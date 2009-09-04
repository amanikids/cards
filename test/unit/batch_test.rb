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
      Factory.create(:item, :batch => batch, :list => Factory.create(:order))
      batch.ship!
      assert_equal shipped_at.to_i, batch.reload.shipped_at.to_i
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

=begin
    should 'increment shipped inventory for each item when a batch is shipped' do
      @order.save!

      shipment = Factory.build(:shipment, :order => @order)

      expected_differences = @order.items.map { |item| item.product_count }
      actual_differences = @capture_count_differences.call(:shipped, lambda {
        shipment.save!
      })
      assert_equal expected_differences, actual_differences
    end

    should 'decrement shipped inventory for each item on shipment destroy' do
      @order.save!

      shipment = Factory.build(:shipment, :order => @order)
      shipment.save!

      expected_differences = @order.items.map { |item| -item.product_count }
      actual_differences = @capture_count_differences.call(:shipped, lambda {
        shipment.destroy
      })
      assert_equal expected_differences, actual_differences
    end
=end
end
