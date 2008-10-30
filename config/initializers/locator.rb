if Rails.env.test?
  Locator.service = AlwaysUnitedStates.new
else
  Locator.service = WebLookup.new
end
