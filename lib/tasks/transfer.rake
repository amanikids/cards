desc <<-DESC
Transfer an Order to another Distributor
Usage: rake transfer order=TOKEN to=COUNTRY_CODE
DESC
task :transfer do
  token        = ENV['order'] || abort(Rake.application.lookup(:transfer).comment)
  country_code = ENV['to']    || abort(Rake.application.lookup(:transfer).comment)

  order       = Order.find_by_token!(token)
  distributor = Distributor.find_by_country_code!(country_code)
  order.transfer!(distributor)
end
