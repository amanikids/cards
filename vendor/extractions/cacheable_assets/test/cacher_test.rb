require 'test/helper'

class CacherTest < Test::Unit::TestCase
  def test_returns_the_delegate_from_new_if_given_no_cache
    delegate = proc { 42 }
    cacher   = Cacher.new(delegate, nil)

    assert_equal delegate, cacher
  end

  def test_stores_delegate_responses
    results  = {}
    delegate = proc do |number|
                 raise 'Not caching?!' if results.key?(number)
                 results[number] = number * 2
               end

    store    = Store.new
    cacher   = Cacher.new(delegate, store)

    assert_equal 2, cacher.call(1)
    assert_equal 8, cacher.call(4)

    assert_nothing_raised do
      cacher.call(1)
    end
  end

  private

  # Would like to just use a Hash, but Hash#fetch with a block doesn't hang
  # onto the return value of the block.
  class Store
    def initialize
      @store = {}
    end

    def fetch(key, &block)
      @store[key] ||= block.call
    end
  end
end
