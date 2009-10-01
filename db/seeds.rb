# =============================================================================
# = Helper Methods                                                            =
# =============================================================================
def password(name)
  name = name.to_s.upcase

  if Rails.env.production?
    ENV[name] || raise("No password specified for #{name}; ENV keys are #{ENV.keys.sort.inspect}")
  else
    'foo'
  end
end

# =============================================================================
# = Users                                                                     =
# =============================================================================
User.create!(:name => 'Matthew Todd', :email => 'matthew.todd@gmail.com', :password => password(:matthew))
User.create!(:name => 'Joe Ventura',  :email => 'joe@amanikids.org',      :password => password(:joe))
User.create!(:name => 'Valerie Todd', :email => 'valerie@amanikids.org',  :password => password(:valerie))

# =============================================================================
# = Distributors                                                              =
# =============================================================================
us = Distributor.create!(:name => 'Dina Sciarra', :email => 'amanikids@comcast.net', :password => password(:dina), :country_code => 'us', :country => 'United States',  :currency => 'USD', :position => 1).tap do |distributor|
  distributor.donation_methods.create!(:position => 1, :name => 'paypal', :title => 'Donate Online', :description => "Donations made in support of the Amani Children's Home Christmas and Holiday Card fundraiser are processed through Peace House Africa using PayPal. Peace House Africa is a registered 501(c)3 charity in the United States committed to bringing educational opportunities to vulnerable children in Africa. Peace House Africa sends 100% of your donation to Amani Children's Home in Tanzania.", :account => 'donation.notify@peacehousefoundation.org')
  distributor.donation_methods.create!(:position => 2, :name => 'check',  :title => 'Mail a Check',  :description => "Make your check payable to \"Friends of Amani US\" and send it to:\n\nDina Sciarra\n32 Teak Loop\nOscala, FL\n24472")
end

ca = Distributor.create!(:name => 'Randy Bacchus', :email => 'randy.bacchus@sage.com', :password => password(:randy), :country_code => 'ca', :country => 'Canada', :currency => 'CAD', :position => 2).tap do |distributor|
  distributor.donation_methods.create!(:position => 1, :name => 'paypal', :title => 'Donate Online', :description => "Donations made in support of the Amani Children's Home Christmas and Holiday Card fundraiser are made through Friends of Amani Canada, a registered charity in Canada, and are processed by PayPal. Friends of Amani Canada transfers 100% of donations received to Amani Children's Home in Tanzania.", :account => 'info@friendsofamani.ca')
  distributor.donation_methods.create!(:position => 2, :name => 'cheque', :title => 'Mail a Cheque', :description => "Make your cheque payable to \"Friends of Amani Canada\" and send it to:\n\nRandy Bacchus\nSage\n50 Burnhamthorpe Rd. West\nSte 700\nMississauga, ON\nL5B 3C2")
end

uk = Distributor.create!(:name => 'Fiona McElhone', :email => 'fiona_mcelhone@hotmail.com', :password => password(:fiona), :country_code => 'uk', :country => 'United Kingdom', :currency => 'GBP', :position => 3).tap do |distributor|
  distributor.donation_methods.create!(:position => 1, :name => 'justgiving', :title => 'Donate at JustGiving', :description => "You can make your donation to Friends of Amani UK through \"JustGiving.com\":http://justgiving.com/amanichildren/donate. Friends of Amani UK is a volunteer-run charity supporting Amani Children's Home. The money raised by Friends of Amani UK is sent to Amani Children's Home in Moshi, Tanzania.\n\nYour donations to Friends of Amani UK are eligible for Gift Aid in the United Kingdom.")
  distributor.donation_methods.create!(:position => 2, :name => 'cheque', :title => 'Mail a Cheque', :description => "Make your cheque to \"Friends of Amani UK\" and send it to:\n\nFiona McElhone\nFlat B\n27 Barnsbury Park\nLondon\nN1 1HQ\n\nDonations are eligible for Gift Aid in the UK.")
end

# =============================================================================
# = Card Number One                                                           =
# =============================================================================
Product.create!(:name => 'Peace on Earth', :position => 1, :image_path => 'cards/peace_on_earth_north_america.jpg', :description => "Amani means \"Peace\" in Swahili. Through rescuing homeless children and giving them a safe and loving home, Amani brings peace into their lives. Spread the important message of peace this Christmas season with this lovely holiday card. At the same time, you'll be ensuring that children in Tanzania have the chance to know the true meaning of peace.\n\n**Inside Message:** May the peace and beauty of the season be yours throughout the year.").tap do |card|
  card.variants.create!(:size => 10, :cents => 1200, :currency => 'USD', :position => 1)
  card.variants.create!(:size => 25, :cents => 2500, :currency => 'USD', :position => 2)
  card.inventories.create!(:distributor => us, :initial => 2000)
  card.inventories.create!(:distributor => ca, :initial => 1000)
end

Product.create!(:name => 'Peace on Earth', :position => 2, :image_path => 'cards/peace_on_earth_uk.jpg', :description => "Amani means \"Peace\" in Swahili. Through rescuing homeless children and giving them a safe and loving home, Amani brings peace into their lives. Spread the important message of peace this Christmas season with this lovely holiday card. At the same time, you'll be ensuring that children in Tanzania have the chance to know the true meaning of peace.").tap do |card|
  card.variants.create!(:size => 10, :cents => 1200, :currency => 'USD', :position => 1)
  card.variants.create!(:size => 25, :cents => 2500, :currency => 'USD', :position => 2)
  card.inventories.create!(:distributor => uk, :initial => 1000)
end

# =============================================================================
# = Card Number Two                                                           =
# =============================================================================
Product.create!(:name => 'Christmas on the Savannah', :position => 3, :image_path => 'cards/christmas_on_the_savannah.jpg', :description => "Amani Children's Home is located in Tanzania, East Africa. The Umbrella Thorn Acacia tree, featured here, is one of Tanzania's many iconic images. Help spread the hope and joy of the holiday season with this beautiful Christmas card. The proceeds from the sale of this card will be used to fund the education of a child that Amani works with, giving them the gift of an education every day of the year.\n\n**Inside Message:** Tis the Season... for peace, love, and joy!").tap do |card|
  card.variants.create!(:size => 10, :cents => 1200, :currency => 'USD', :position => 1)
  card.variants.create!(:size => 25, :cents => 2500, :currency => 'USD', :position => 2)
  card.inventories.create!(:distributor => us, :initial => 1000)
  card.inventories.create!(:distributor => ca, :initial => 1000)
end

Product.create!(:name => 'Christmas on the Savannah', :position => 4, :image_path => 'cards/christmas_on_the_savannah.jpg', :description => "Amani Children's Home is located in Tanzania, East Africa. The Umbrella Thorn Acacia tree, featured here, is one of Tanzania's many iconic images. Help spread the hope and joy of the holiday season with this beautiful Christmas card. The proceeds from the sale of this card will be used to fund the education of a child that Amani works with, giving them the gift of an education every day of the year.").tap do |card|
  card.variants.create!(:size => 10, :cents => 1200, :currency => 'USD', :position => 1)
  card.variants.create!(:size => 25, :cents => 2500, :currency => 'USD', :position => 2)
  card.inventories.create!(:distributor => uk, :initial => 1000)
end

# =============================================================================
# = Gift Cards                                                                =
# =============================================================================
Product.create!(:name => 'Amani Alternative Gift Cards', :position => 5, :image_path => 'cards/gift_card.jpg', :description => "Instead of a traditional gift, you can honor your loved ones by making a donation in their name to Amani Children's Home. Just $16 will provide a set of sheets and blankets for a bed at Amani and $200 will cover the first semester of secondary school for an Amani child.   For this holiday season, consider giving the gift of hope! Order your Alternative Gift Cards today! Here are some of the alternative gift options:").tap do |card|
  [
    ['Textbook',                                   400],
    ['School Uniform',                            1000],
    ['Bedding (sheet and blanket)',               1600],
    ['Sports equipment (Cleats, balls, jerseys)', 2500],
    ['Art supplies',                              3000],
    ['Drums',                                     4000],
    ['Medical Supplies',                          5000],
    ['Desk and chair',                            6000],
    ['Pots',                                     10000],
    ['First semester of secondary school',       20000]
  ].each_with_index do |(name, cost_in_cents), index|
    card.variants.create!(:name => name, :cents => cost_in_cents, :currency => 'USD', :position => index + 1)
  end
end
