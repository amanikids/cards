require 'test_helper'

class LocatorTest < ActiveSupport::TestCase
  should_have_named_scope 'ip_address(305419896)', :conditions => ['ip_from <= ? AND ip_to >= ?', 305419896, 305419896]

  should 'convert an ip address string into an integer' do
    assert_equal 305419896, Locator.convert('18.52.86.120')
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
