User.find_each do |user|
  user.update_attributes!(:password => 'secret')
end

Store.find_or_initialize_by_slug('us').tap do |store|
  store.distributor    = User.find_by_email!('matthew@amanikids.org')
  store.paypal_account = PaypalAccount.find_or_initialize_by_login(ENV['PAYPAL_LOGIN']).tap do |account|
    account.update_attributes!(
      :password  => ENV['PAYPAL_PASSWORD'],
      :signature => ENV['PAYPAL_SIGNATURE']
    )
  end
  store.update_attributes!(
    :name     => 'United States',
    :currency => 'USD'
  )

  store.products.find_or_initialize_by_name('Poinsettia').tap do |card|
    card.update_attributes!(:price => 10)
  end

  store.carts.create!.tap do |cart|
    cart.items.create!(
      :product_id => store.products.first.id,
      :quantity   => 1
    )

    Order.new.tap do |order|
      order.address = Address.create!(
        :name    => 'Bob Loblaw',
        :line_1  => '123 Main St.',
        :line_2  => 'Anytown, NY 09876',
        :country => 'United States'
      )
      order.cart    = cart
      order.payment = PaypalPayment.create!(
        :token    => 'foo',
        :payer_id => 'bar'
      )
    end.save!
  end
end

