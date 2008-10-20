class Order < List
  def donor_editable?
    false
  end

  def to_param
    token
  end
end