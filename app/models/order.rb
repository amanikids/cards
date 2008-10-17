class Order < List
  validates_uniqueness_of :token

  def donor_editable?
    false
  end

  def to_param
    token
  end
end