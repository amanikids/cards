def prompt(message, default)
  print "#{message}"
  print " (#{default})" if default
  print ": "

  response = $stdin.gets.strip
  response = default if response.empty?
  response
end

def administrators(*emails)
  users(*emails) do |user|
    unless user.administrator?
      Administratorship.new.tap do |admin|
        admin.user = user
        admin.save!
      end
    end
  end
end

def just_giving(charity_identifier)
  JustgivingAccount.find_or_create_by_charity_identifier(charity_identifier)
end

def on_demand_product(name, description, image_path)
  @products = Store.all.map do |store|
    store.products.find_or_initialize_by_name(name).tap do |card|
      card.description = description
      card.image_path  = image_path
      card.on_demand   = true
      card.save!
    end
  end
end

def packaging(name, *pricings)
  pricings.each { |pricing| pricing.call(name, @products) }
end

def pay_pal(login)
  PaypalAccount.find_or_initialize_by_login(login).tap do |account|
    account.password  = prompt("password for #{login}",  account.password)
    account.signature = prompt("signature for #{login}", account.signature)
    account.save!
  end
end

def pricing(currency, price_cents)
  lambda do |name, products|
    product = products.find { |p| p.store.currency == currency }
    product.packagings.find_or_initialize_by_name(name).tap do |packaging|
      packaging.price = price_cents
      packaging.size  = 1
      packaging.save!
    end
  end
end

def CAD(amount)
  pricing('CAD', amount * 100)
end

def GBP(amount)
  pricing('GBP', amount * 100)
end

def USD(amount)
  pricing('USD', amount * 100)
end

def store(slug, currency, name, account, description, *distributor_emails)
  Store.find_or_initialize_by_slug(slug).tap do |store|
    store.account         = account
    store.distributor_ids = users(distributor_emails).map(&:id)
    store.name            = name
    store.currency        = currency
    store.description     = description
    store.save!
  end
end

def users(*emails)
  emails.map do |email|
    User.find_or_initialize_by_email(email).tap do |user|
      user.randomize_password! if user.new_record?
      yield user if block_given?
      user.save!
    end
  end
end

common   = Rails.root.join("db/seeds/common.rb")
specific = Rails.root.join("db/seeds/#{Rails.env}.rb")

require common
require specific if specific.exist?
