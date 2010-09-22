# =============================================================================
# = Helper Methods                                                            =
# =============================================================================
def make_user(name, email)
  User.find_or_initialize_by_name(name).tap do |user|
    user.email    = email
    user.password = make_password if user.new_record?
    user.save!
  end
end

def make_distributor(position, country_code, country, currency, name, email)
  Distributor.find_or_initialize_by_country_code(country_code).tap do |distributor|
    distributor.position = position
    distributor.country  = country
    distributor.currency = currency
    distributor.name     = name
    distributor.email    = email
    distributor.password = make_password if distributor.new_record?
    distributor.save!
  end
end

def make_password
  if Rails.env.production?
    ActiveSupport::SecureRandom.hex
  else
    'secret'
  end
end

# =============================================================================
# = Users                                                                     =
# =============================================================================
make_user 'Matthew Todd', 'matthew.todd@gmail.com'
make_user 'Joe Ventura',  'joe@amanikids.org'
make_user 'Salma Daud',   'salma@amanikids.org'
make_user 'Valerie Todd', 'valerie@amanikids.org'

# =============================================================================
# = Distributors                                                              =
# =============================================================================
# United States
us = make_distributor(1, 'us', 'United States', 'USD', 'Dina Sciarra', 'amanikids@comcast.net').tap do |distributor|
  distributor.donation_methods.find_or_create_by_name('paypal').tap do |method|
    method.update_attributes!(
      :position    => 1,
      :name        => 'paypal',
      :title       => 'Donate Online',
      :description => "Donations made in support of the Amani Children's Home Christmas and Holiday Card fundraiser are processed through Peace House Africa using PayPal. Peace House Africa is a registered 501(c)3 charity in the United States committed to bringing educational opportunities to vulnerable children in Africa. Peace House Africa sends 100% of your donation to Amani Children's Home in Tanzania.",
      :account     => 'donation.notify@peacehousefoundation.org'
    )
  end

  distributor.donation_methods.find_or_create_by_name('check').tap do |method|
    method.update_attributes!(
      :position => 2,
      :name => 'check',
      :title => 'Mail a Check',
      :description => "Make your check payable to \"Friends of Amani US\" and send it to:\n\nDina Sciarra\n32 Teak Loop\nOcala, FL\n34472"
    )
  end
end

# Canada
ca = make_distributor(2, 'ca', 'Canada', 'CAD', 'Randy Bacchus', 'randy.bacchus@sage.com').tap do |distributor|
  distributor.donation_methods.find_or_initialize_by_name('paypal').tap do |method|
    method.update_attributes!(
      :position    => 1,
      :title       => 'Donate Online',
      :description => "Donations made in support of the Amani Children's Home Christmas and Holiday Card fundraiser are made through Friends of Amani Canada, a registered charity in Canada, and are processed by PayPal. Friends of Amani Canada transfers 100% of donations received to Amani Children's Home in Tanzania.",
      :account     => 'info@friendsofamani.ca'
    )
  end

  distributor.donation_methods.find_or_initialize_by_name('cheque').tap do |method|
    method.update_attributes!(
      :position    => 2,
      :title       => 'Mail a Cheque',
      :description => "Make your cheque payable to \"Friends of Amani Canada\" and send it to:\n\nRandy Bacchus\nSage\n50 Burnhamthorpe Rd. West\nSte 700\nMississauga, ON\nL5B 3C2"
    )
  end
end

# United Kingdom
uk = make_distributor(3, 'uk', 'United Kingdom', 'GBP', 'Fiona McElhone', 'fiona_mcelhone@hotmail.com').tap do |distributor|
  distributor.donation_methods.find_or_initialize_by_name('justgiving').tap do |method|
    method.update_attributes!(
      :position => 1,
      :title => 'Donate at JustGiving',
      :description => "You can make your donation to Friends of Amani UK through \"JustGiving.com\":http://justgiving.com/amanichildren/donate. Friends of Amani UK is a volunteer-run charity supporting Amani Children's Home. The money raised by Friends of Amani UK is sent to Amani Children's Home in Moshi, Tanzania.\n\nYour donations to Friends of Amani UK are eligible for Gift Aid in the United Kingdom."
    )
  end

  distributor.donation_methods.find_or_initialize_by_name('cheque').tap do |method|
    method.update_attributes!(
      :position    => 2,
      :title       => 'Mail a Cheque',
      :description => "Make your cheque to \"Friends of Amani UK\" and send it to:\n\nFiona McElhone\n213 Liverpool Road\nLondon\nN1 1LX\n\nDonations are eligible for Gift Aid in the UK."
    )
  end
end

# =============================================================================
# = Card Number One                                                           =
# =============================================================================
Product.find_or_initialize_by_image_path('cards/peace_on_earth_north_america.jpg').tap do |card|
  card.update_attributes!(
    :position    => 1,
    :name        => 'Peace on Earth',
    :short_name  => 'Doves',
    :description => "Amani means \"Peace\" in Swahili. Through rescuing homeless children and giving them a safe and loving home, Amani brings peace into their lives. Spread the important message of peace this Christmas season with this lovely holiday card. At the same time, you'll be ensuring that children in Tanzania have the chance to know the true meaning of peace.\n\n**Inside Message:** May the peace and beauty of the season be yours throughout the year."
  )

  card.variants.find_or_initialize_by_size(10).tap { |pack| pack.update_attributes!(:position => 1, :cents => 1200, :currency => 'USD') }
  card.variants.find_or_initialize_by_size(25).tap { |pack| pack.update_attributes!(:position => 2, :cents => 2500, :currency => 'USD') }
  card.inventories.find_or_initialize_by_distributor_id(us.id).tap { |stock| stock.update_attributes!(:initial => 3790) }
  card.inventories.find_or_initialize_by_distributor_id(ca.id).tap { |stock| stock.update_attributes!(:initial => 2028) }
end

Product.find_or_initialize_by_image_path('cards/peace_on_earth_uk.jpg').tap do |card|
  card.update_attributes!(
    :position    => 2,
    :name        => 'Peace on Earth',
    :short_name  => 'Doves',
    :description => "Amani means \"Peace\" in Swahili. Through rescuing homeless children and giving them a safe and loving home, Amani brings peace into their lives. Spread the important message of peace this Christmas season with this lovely holiday card. At the same time, you'll be ensuring that children in Tanzania have the chance to know the true meaning of peace."
  )

  card.variants.find_or_initialize_by_size(10) { |pack| pack.update_attributes!(:position => 1, :cents => 1200, :currency => 'USD') }
  card.variants.find_or_initialize_by_size(25) { |pack| pack.update_attributes!(:position => 2, :cents => 2500, :currency => 'USD') }
  card.inventories.find_or_initialize_by_distributor_id(uk.id) { |stock| stock.update_attributes!(:initial => 2000) }
end

# =============================================================================
# = Card Number Two                                                           =
# =============================================================================
Product.find_or_initialize_by_image_path('cards/christmas_on_the_savannah_north_america.jpg').tap do |card|
  card.update_attributes!(
    :position    => 3,
    :name        => 'Christmas on the Savannah',
    :short_name  => 'Trees',
    :description => "Amani Children's Home is located in Tanzania, East Africa. The Umbrella Thorn Acacia tree, featured here, is one of Tanzania's many iconic images. Help spread the hope and joy of the holiday season with this beautiful Christmas card. The proceeds from the sale of this card will be used to fund to fund the education of children who Amani works with, giving them the gift of an education every day of the year.\n\n**Inside Message:** Tis the Season... for peace, love, and joy!"
  )

  card.variants.find_or_initialize_by_size(10).tap { |pack| pack.update_attributes!(:position => 1, :cents => 1200, :currency => 'USD') }
  card.variants.find_or_initialize_by_size(25).tap { |pack| pack.update_attributes!(:position => 2, :cents => 2500, :currency => 'USD') }
  card.inventories.find_or_initialize_by_distributor_id(us.id).tap { |stock| stock.update_attributes!(:initial => 4230) }
  card.inventories.find_or_initialize_by_distributor_id(ca.id).tap { |stock| stock.update_attributes!(:initial => 954) }
end

Product.find_or_initialize_by_image_path('cards/christmas_on_the_savannah_uk.jpg').tap do |card|
  card.update_attributes!(
    :position    => 4,
    :name        => 'Christmas on the Savannah',
    :short_name  => 'Trees',
    :description => "Amani Children's Home is located in Tanzania, East Africa. The Umbrella Thorn Acacia tree, featured here, is one of Tanzania's many iconic images. Help spread the hope and joy of the holiday season with this beautiful Christmas card. The proceeds from the sale of this card will be used to fund to fund the education of children who Amani works with, giving them the gift of an education every day of the year."
  )

  card.variants.find_or_initialize_by_size(10).tap { |pack| pack.update_attributes!(:position => 1, :cents => 1200, :currency => 'USD') }
  card.variants.find_or_initialize_by_size(25).tap { |pack| pack.update_attributes!(:position => 2, :cents => 2500, :currency => 'USD') }
  card.inventories.find_or_initialize_by_distributor_id(uk.id).tap { |stock| stock.update_attributes!(:initial => 1500) }
end

# =============================================================================
# = Card Number Three (Leftover from Last Year)                               =
# =============================================================================
Product.find_or_initialize_by_image_path('cards/2008_peace.jpg').tap do |card|
  card.update_attributes!(
    :position    => 5,
    :name        => '"Peace" around the World',
    :short_name  => 'Stars',
    :description => "Together, we're making a difference in the lives of Tanzania's orphans and homeless children. By giving them a safe and loving home, Amani brings peace into their lives. Spread the important message of peace this Christmas season with this lovely holiday card. At the same time, you'll be ensuring that children in Tanzania have the chance to know the true meaning of peace.\n\n**Inside Message:** May peace reign throughout the world and joy be found in every heart. Merry Christmas!"
  )

  card.variants.find_or_initialize_by_size(10).tap { |pack| pack.update_attributes!(:position => 1, :cents => 1200, :currency => 'USD') }
  card.variants.find_or_initialize_by_size(25).tap { |pack| pack.update_attributes!(:position => 2, :cents => 2500, :currency => 'USD') }
  card.inventories.find_or_initialize_by_distributor_id(us.id).tap { |stock| stock.update_attributes!(:initial => 590) }
end

# =============================================================================
# = Gift Cards                                                                =
# =============================================================================
Product.find_or_initialize_by_image_path('cards/gift_card.jpg').tap do |card|
  card.update_attributes!(
    :position    => 6,
    :name        => 'Amani Alternative Gift Cards',
    :description => "Instead of a traditional gift, you can honor your loved ones by making a donation in their name to Amani Children's Home. Just $16 will provide a set of sheets and blankets for a bed at Amani and $200 will cover the first semester of secondary school for an Amani child. For this holiday season, consider giving the gift of hope! Order your Alternative Gift Cards today! Here are some of the alternative gift options:"
  )

  # Set up the options we currently offer
  card.variants.find_or_initialize_by_name('School textbooks').tap                   { |c| c.update_attributes!(:cents => 400,   :currency => 'USD') }
  card.variants.find_or_initialize_by_name('School uniform').tap                     { |c| c.update_attributes!(:cents => 1000,  :currency => 'USD') }
  card.variants.find_or_initialize_by_name('Bedding (sheets and blankets)').tap      { |c| c.update_attributes!(:cents => 1600,  :currency => 'USD') }
  card.variants.find_or_initialize_by_name('Sports equipment').tap                   { |c| c.update_attributes!(:cents => 2500,  :currency => 'USD') }
  card.variants.find_or_initialize_by_name('Traditional drums').tap                  { |c| c.update_attributes!(:cents => 4000,  :currency => 'USD') }
  card.variants.find_or_initialize_by_name('Desk and chair').tap                     { |c| c.update_attributes!(:cents => 6000,  :currency => 'USD') }
  card.variants.find_or_initialize_by_name('Food for 1 child for 6 months').tap      { |c| c.update_attributes!(:cents => 10000, :currency => 'USD') }
  card.variants.find_or_initialize_by_name('First semester of secondary school').tap { |c| c.update_attributes!(:cents => 20000, :currency => 'USD') }

  # And make sure they're sorted by amount
  card.variants.all(:order => :cents).each_with_index { |option, position| option.update_attributes!(:position => position.succ) }
end

# =============================================================================
# = Warm Fuzzies                                                              =
# =============================================================================
puts 'Database seeding done.'
