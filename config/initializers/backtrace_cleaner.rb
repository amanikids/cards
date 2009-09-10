require 'rails/backtrace_cleaner'

module Rails
  class BacktraceCleaner < ActiveSupport::BacktraceCleaner
    private
      GEM_REGEX = "([A-Za-z0-9_-]+)-([0-9.]+)"

      def add_gem_filters
        Gem.path.each do |path|
          # http://gist.github.com/30430
          add_filter { |line| line.sub(/(#{path})\/gems\/#{GEM_REGEX}\/(.*)/, '\2 (\3) \4')}
        end

        vendor_gems_path = Rails::GemDependency.unpacked_path.sub("#{RAILS_ROOT}/",'')
        add_filter { |line| line.sub(/(#{vendor_gems_path})\/#{GEM_REGEX}\/(.*)/, '\2 (\3) [v] \4')}
      end
  end
end
