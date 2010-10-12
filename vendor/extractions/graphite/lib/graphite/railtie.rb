require 'graphite'
require 'rails'

module Graphite
  class Railtie < Rails::Railtie
    rake_tasks do
      load 'graphite/tasks/graphite.rake'
    end
  end
end
