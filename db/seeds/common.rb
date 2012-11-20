STORE_DESCRIPTION = <<-END
Thank you for being interested in purchasing Amani Christmas, holiday and gift cards. Each year, sales of the cards raise money to pay for school fees, textbooks and school lunches in the upcoming academic year. Every purchase makes an impact, from pencils to backpacks.

From the card design to distribution to the website order form, volunteers are helping to keep Amani's costs minimal so that profits from the sales of the card go directly to help the children. Cards will be shipped directly to you from one of Amani's volunteer distributors in the United States, Canada, the United Kingdom and Australia.
END

GIFT_CARD_DESCRIPTION = <<-END
Looking for the perfect gift for that special someone in your life who is hard to shop for or simply has everything? Please give the gift of hope to a homeless child! Purchase one or many of these Amani gift cards, and we'll send you the card in a holiday envelope ready for giving. And, if you provide us with the recipient's name and address in the comment section when making your card purchase using PayPal, we'll send it directly to your special someone for you.

Rescuing Children, Restoring Hope, Transforming Lives... it's all happening at Amani thanks to YOU.
END

administrators 'diane@amanikids.org',
  'kristy@amanikids.org',
  'matthew@amanikids.org'

store 'ca', 'CAD',
  'Canada',
  pay_pal('info_api1.friendsofamani.ca'),
  'No text here.',
  'diane@amanikids.org'

store 'uk', 'GBP',
  'United Kingdom & Europe',
  just_giving('182061'),
  'No text here.',
  'diane@amanikids.org'

store 'us', 'USD',
  'United States & all other countries',
  pay_pal('diane_api1.amanikids.org'),
  'No text here.',
  'diane@amanikids.org'

on_demand_product 'Amani Gift Cards',
  GIFT_CARD_DESCRIPTION,
  '2012/gift_card.png'

packaging 'School Uniform',                   CAD(15),  GBP(10),  USD(15)
packaging 'Sports Equipment',                 CAD(25),  GBP(16),  USD(25)
packaging 'Health Care Visits',               CAD(50),  GBP(32),  USD(50)
packaging 'School Textbooks',                 CAD(50),  GBP(32),  USD(50)
packaging 'Nutritious Food',                 CAD(100),  GBP(65), USD(100)
packaging 'Semester of Secondary Education', CAD(200), GBP(130), USD(200)
