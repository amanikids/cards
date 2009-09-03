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

  context '#order' do
    should 'return the order of the first item' do
      order = Factory.create(:order)
      batch = Factory.create(:item, :list => order).batch
      assert_equal order, batch.order
    end
  end
end
