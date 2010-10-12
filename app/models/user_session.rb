class UserSession
  include ActiveModel::MassAssignmentSecurity
  include ActiveModel::Validations

  attr_accessor   :email, :password, :session, :user
  attr_accessible :email, :password

  class AuthenticValidator < ActiveModel::Validator
    def validate(record)
      return unless record.errors.empty?
      record.user = User.authenticate(record.email, record.password)
      record.errors.add(:base, :authentication_failed) if record.user.blank?
    end
  end

  validates :email,    :presence  => true, :unless => :user
  validates :password, :presence  => true, :unless => :user
  validates :user,     :authentic => true, :unless => :user

  class << self
    def find(session)
      UserSession.new(session, User.find(session[:user_id]))
    rescue ActiveRecord::RecordNotFound
      nil
    end
  end

  def initialize(session=nil, user_or_attributes={})
    self.session = session

    case user_or_attributes
    when User
      self.user = user_or_attributes
    else
      self.attributes = user_or_attributes
    end
  end

  def attributes=(attributes)
    sanitize_for_mass_assignment(attributes).each do |key, value|
      send "#{key}=", value
    end
  end

  def destroy
    session[:user_id] = nil
  end

  def persisted?
    false
  end

  def save
    if valid?
      session[:user_id] = user.id
    end
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
