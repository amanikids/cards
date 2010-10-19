module Checkout
  class PayPal
    include ActiveModel::Validations

    def initialize(cart=nil)

    end

    def persisted?
      false
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
  end
end
