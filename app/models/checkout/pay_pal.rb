module Checkout
  class PayPal
    include ActiveModel::Validations

    attr_reader :token

    def initialize(cart=nil)

    end

    def persisted?
      false
    end

    def save
      response = api.post({})
      params   = Rack::Utils.parse_query(response.body)
      @token = params['TOKEN']
    end

    def to_key
      nil
    end

    def to_model
      self
    end

    def to_param
      nil
    end

    private

    def api
      RestClient::Resource.new('https://api-3t.paypal.com/nvp')
    end
  end
end
