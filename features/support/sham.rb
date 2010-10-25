Spork.each_run do
  Before do
    Capybara.app = Rails.application
    ShamRack.unmount_all
  end
end
