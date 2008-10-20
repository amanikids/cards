class List < ActiveRecord::Base
  has_one :address
  has_many :items
  before_create :write_token

  def quantity
    quantity = 0
    items.each { |item| quantity += item.quantity }
    quantity
  end

  def to_param
    token
  end

  def total
    total = Money.new(0)
    items.each { |item| total += item.total }
    total
  end

  private

  def write_token
    self.token = Digest::SHA1.hexdigest(random_string)
  end

  def random_string
    Time.now.to_s.split(//).sort_by { rand }.join
  end
end
