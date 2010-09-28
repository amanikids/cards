module CacheableAssets
  class Cacher
    def self.new(delegate, store)
      store ? super : delegate
    end

    def initialize(delegate, store)
      @delegate = delegate
      @store    = store
    end

    def call(*args)
      @store.fetch key(*args) do
        @delegate.call(*args)
      end
    end

    private

    def key(*args)
      [self.class, @delegate.class, *args].join('-')
    end
  end
end
