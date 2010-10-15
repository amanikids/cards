class Cart

  class Item
    extend ActiveModel::Naming

    attr_accessor :product_id

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
