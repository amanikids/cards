class List < ActiveRecord::Base
  belongs_to :address
  has_many :items

  delegate :country, :email, :name, :to => :address

  before_create :write_token

  def all_downloads?
    items.all?(&:download) unless items.blank?
  end

  def downloads
    items.collect(&:download).compact
  end

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
