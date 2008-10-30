if Rails.env.test?
  Locator.service = Locator::AlwaysUnitedStates.new
end
