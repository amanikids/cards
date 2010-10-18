class Cart
  include ActiveModel::Validations

  class << self
    def find(session)
      new(session, session[:cart])
    end
  end

  attr_accessor :session

  def initialize(session={}, attributes={})
    self.session    = session
    self.attributes = attributes
  end

  def ==(other)
    self.items == other.items
  end

  def attributes=(attributes)

  end

  def items

  end

  def persisted?
    false
  end

  def save
    session[:cart] = attributes
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
