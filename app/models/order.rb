class Order < List
  validates_uniqueness_of :token

  def to_param
    token
  end
end