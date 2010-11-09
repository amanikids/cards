class UserSession
  include ActiveModel::MassAssignmentSecurity
  include ActiveModel::Validations
  include ActiveModel::Validations::Callbacks

  attr_accessor :email
  attr_accessor :password
  attr_accessor :session
  attr_accessor :user

  attr_accessible :email
  attr_accessible :password

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

  after_validation :clear_password

  class << self
    def find(session)
      UserSession.new(session, User.find(session[:user_id]))
    rescue ActiveRecord::RecordNotFound
      nil
    end
  end

  def initialize(session=nil, credentials={})
    self.session     = session
    self.credentials = credentials
  end

  def attributes=(attributes)
    sanitize_for_mass_assignment(attributes).each do |key, value|
      send "#{key}=", value
    end
  end

  def destroy
    session[:user_id] = nil
  end

  # stolen from rspec-rails
  def errors_on(attribute)
    self.valid?
    [self.errors[attribute]].flatten.compact
  end
  alias :error_on :errors_on

  def persisted?
    false
  end

  def save
    if valid?
      session[:user_id] = user.id
    end
  end

  # Haml calls object#id when you say %tag[object], so ruby warns us we should
  # use object#object_id instead. I'd rather not see those warning messages!
  def id
    to_param
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

  private

  def clear_password
    self.password = nil
  end

  def credentials=(credentials)
    case credentials
    when User
      self.user = credentials
    else
      self.attributes = credentials
    end
  end
end
