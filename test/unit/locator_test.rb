require File.join(File.dirname(__FILE__), '..', 'test_helper')

class LocatorTest < ActiveSupport::TestCase
  context 'named scope for an ip address' do
    should 'return a locator that encompasses the given ip address' do
      too_low   = Factory.create(:locator, :ip_from => 1, :ip_to => 2)
      matching  = Factory.create(:locator, :ip_from => 3, :ip_to => 3)
      too_high  = Factory.create(:locator, :ip_from => 4, :ip_to => 5)

      assert_equal [matching], Locator.ip_address(3)
    end
  end

  should 'convert an ip address string into an integer' do
    assert_equal 305419896, Locator.convert('18.52.86.120')
  end

  should 'convert an ip address string into an integer faced with 1-digit octets' do
    assert_equal 0x01010101, Locator.convert('1.1.1.1')
  end

  should 'convert nil to zero' do
    assert_equal 0, Locator.convert(nil)
  end

  should 'convert blank string to zero' do
    assert_equal 0, Locator.convert('')
  end

  should 'look up a country code for ip address string' do
    Locator.expects(:convert).with('IP_ADDRESS_STRING').returns('IP_ADDRESS')
    Locator.expects(:ip_address).with('IP_ADDRESS').returns [Locator.new(:country_code => 'COUNTRY_CODE')]
    assert_equal 'country_code', Locator.country_code('IP_ADDRESS_STRING')
  end

  should 'return nil when no results found' do
    Locator.stubs(:convert).with('IP_ADDRESS_STRING').returns('IP_ADDRESS')
    Locator.stubs(:ip_address).with('IP_ADDRESS').returns([])
    assert_nil Locator.country_code('IP_ADDRESS_STRING')
  end

  should 'convert GB to UK' do
    Locator.stubs(:convert).with('IP_ADDRESS_STRING').returns('IP_ADDRESS')
    Locator.stubs(:ip_address).with('IP_ADDRESS').returns [Locator.new(:country_code => 'GB')]
    assert_equal 'uk', Locator.country_code('IP_ADDRESS_STRING')
  end
end
