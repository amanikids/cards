class Address < ActiveRecord::Base
  belongs_to :list
  validates_presence_of :name, :email, :line_one, :line_two, :country
  validates_format_of :email, :with => /^[a-z0-9._+-]+@([a-z0-9-]+\.)+[a-z]{2,}$/i
end
