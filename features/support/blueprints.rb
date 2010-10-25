Spork.prefork do
  require 'spec/support/blueprints'
end

Spork.each_run do
  Before do
    Machinist.reset_before_test
  end
end
