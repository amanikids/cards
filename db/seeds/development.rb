User.find_each do |user|
  user.update_attributes!(:password => 'secret')
end

Store.find_or_initialize_by_slug('uk').tap do |store|
  store.account     = JustgivingAccount.find_or_create_by_charity_identifier('182061')
  store.distributor = User.find_by_email!('matthew@amanikids.org')
  store.update_attributes!(
    :name     => 'United Kindgom',
    :currency => 'GBP'
  )

  store.products.find_or_initialize_by_name('Poinsettia').tap do |card|
    card.update_attributes!(
      :description => Faker::Lorem.paragraph,
      :image_path  => '2010/poinsettia.jpg'
    )

    card.packagings.find_or_initialize_by_size(10) do |packaging|
      packaging.update_attributes!(
        :name  => '10-pack',
        :price => 1000
      )
    end

    card.packagings.find_or_initialize_by_size(25) do |packaging|
      packaging.update_attributes!(
        :name  => '25-pack',
        :price => 2500
      )
    end
  end

  store.products.find_or_initialize_by_name('Pinebough').tap do |card|
    card.update_attributes!(
      :description => Faker::Lorem.paragraph,
      :image_path  => '2010/pinebough.jpg'
    )

    card.packagings.find_or_initialize_by_size(10) do |packaging|
      packaging.update_attributes!(
        :name  => '10-pack',
        :price => 1000
      )
    end

    card.packagings.find_or_initialize_by_size(25) do |packaging|
      packaging.update_attributes!(
        :name  => '25-pack',
        :price => 2500
      )
    end
  end
end

Store.find_or_initialize_by_slug('us').tap do |store|
  store.account = PaypalAccount.find_or_initialize_by_login(ENV['PAYPAL_LOGIN']).tap do |account|
    account.update_attributes!(
      :password  => ENV['PAYPAL_PASSWORD'],
      :signature => ENV['PAYPAL_SIGNATURE']
    )
  end
  store.distributor = User.find_by_email!('matthew@amanikids.org')
  store.update_attributes!(
    :name     => 'United States',
    :currency => 'USD'
  )

  store.products.find_or_initialize_by_name('Poinsettia').tap do |card|
    card.update_attributes!(
      :description => Faker::Lorem.paragraph,
      :image_path  => '2010/poinsettia.jpg'
    )

    card.packagings.find_or_initialize_by_size(10) do |packaging|
      packaging.update_attributes!(
        :name  => '10-pack',
        :price => 1000
      )
    end

    card.packagings.find_or_initialize_by_size(25) do |packaging|
      packaging.update_attributes!(
        :name  => '25-pack',
        :price => 2500
      )
    end
  end

  store.products.find_or_initialize_by_name('Pinebough').tap do |card|
    card.update_attributes!(
      :description => Faker::Lorem.paragraph,
      :image_path  => '2010/pinebough.jpg'
    )

    card.packagings.find_or_initialize_by_size(10) do |packaging|
      packaging.update_attributes!(
        :name  => '10-pack',
        :price => 1000
      )
    end

    card.packagings.find_or_initialize_by_size(25) do |packaging|
      packaging.update_attributes!(
        :name  => '25-pack',
        :price => 2500
      )
    end
  end
  store.carts.create!.tap do |cart|
    cart.items.create!(
      :packaging_id => store.products.first.packagings.first.id,
      :quantity     => 1
    )

    Order.new.tap do |order|
      order.address = Address.create!(
        :name    => 'Bob Loblaw',
        :line_1  => '123 Main St.',
        :line_2  => 'Anytown, NY 09876',
        :country => 'United States'
      )
      order.cart    = cart
      order.payment = PaypalPayment.new.tap do |payment|
        payment.token    = 'foo',
        payment.payer_id = 'bar'
        payment.save!
      end
    end.save!
  end
end

