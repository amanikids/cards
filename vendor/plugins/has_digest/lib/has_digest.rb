require 'digest/sha1'

module HasDigest
  def self.included(base) # :nodoc:
    base.before_save :generate_has_digest_attributes, :unless => lambda { |record| record.class.has_digest_attributes.empty? }
    base.extend(ClassMethods)
  end

  # Returns a 40-character hexadecimal token. When no +values+ are given, the
  # token is seeded with a randomized form of the current time. When +values+
  # are given, the token is seeded with them instead, unless any of them
  # evaluate to +false+, in which case the returned token is +nil+.
  #
  # +digest+ is available as an instance method on any of your +ActiveRecord+ models, so you can use it as needed. For example:
  #   class User < ActiveRecord::Base
  #     def authenticate(password)
  #       encrypted_password == digest(salt, password)
  #     end
  #   end
  def digest(*values)
    if values.empty?
      Digest::SHA1.hexdigest(Time.now.to_default_s.split(//).sort_by { Kernel.rand }.join)
    elsif values.all?
      Digest::SHA1.hexdigest("--#{values.join('--')}--")
    else
      nil
    end
  end

  def generate_has_digest_attributes # :nodoc:
    if new_record?
      if attribute_names.include?('salt')
        self[:salt] = digest
      end

      self.class.standalone_has_digest_attributes.each do |name, options|
        self[name] = digest
      end
    end

    lookup_value = lambda { |dependency| send(dependency) }
    self.class.dependent_has_digest_attributes.each do |name, options|
      dependencies           = options[:dependencies]
      synthetic_dependencies = options[:synthetic_dependencies]

      if synthetic_dependencies.all?(&lookup_value)
        self[name] = digest(*dependencies.map(&lookup_value))
      end
    end
  end

  module ClassMethods
    # Gives the class it is called on a +before_save+ callback that writes a
    # 40-character hexadecimal string into the given +attribute+. The
    # generated string may depend on other (possibly synthetic) attributes of
    # the model, being automatically regenerated when they change. One key is
    # supported in the +options+ hash:
    # * +depends+: either a single attribute name or a list of attribute
    #   names. If any of these values change, +attribute+ will be re-written.
    #   Setting any (non-synthetic) one of these attributes to +nil+ will
    #   effectively also set +attribute+ to +nil+.
    #
    # ===Magic Salting
    # If the model in question has a +salt+ attribute, its +salt+ be
    # automatically populated on create and automatically mixed into any
    # digests with dependencies on other attributes, saving you a little bit
    # of work when dealing with passwords.
    #
    # ===Magic Synthetic Attributes
    # If the model in question doesn't have a database column for one of your
    # digest dependencies, an +attr_accessor+ for that synthetic dependency
    # will be created automatically. For example, if you write <tt>has_digest
    # :encrypted_password, :depends => :password</tt> and don't have a
    # +password+ column for your model, the +attr_accessor+ for +password+
    # will be automatically created, saving you a redundant line of code.
    #
    # ===Examples
    #   # token will be generated on create
    #   class Order < ActiveRecord::Base
    #     has_digest :token
    #   end
    #
    #   # encrypted_password will be generated on save whenever @password is not nil
    #   # (Automatically calls attr_accessor :password.)
    #   class User < ActiveRecord::Base
    #     has_digest :encrypted_password, :depends => :password
    #   end
    #
    #   # remember_me_token will be generated on save whenever login or remember_me_until have changed.
    #   # User.update_attributes(:remember_me_until => nil) will set remember_me_token to nil.
    #   class User < ActiveRecord::Base
    #     has_digest :remember_me_token, :depends => [:login, :remember_me_until]
    #   end
    #
    #   # api_token will be blank until user.update_attributes(:generate_api_token => true).
    #   # (Automatically calls attr_accessor :generate_api_token.)
    #   class User < ActiveRecord::Base
    #     has_digest :api_token, :depends => :generate_api_token
    #   end
    def has_digest(attribute, options = {})
      options.assert_valid_keys(:depends)

      if options[:depends]
        dependencies = []
        dependencies << :salt if column_names.include?('salt')
        dependencies << options[:depends]
        dependencies.flatten!

        synthetic_dependencies = dependencies - column_names.map(&:to_sym)
        synthetic_dependencies.each { |name| attr_accessor name }

        write_inheritable_hash :has_digest_attributes, attribute => { :dependencies => dependencies, :synthetic_dependencies => synthetic_dependencies }
      else
        write_inheritable_hash :has_digest_attributes, attribute => {}
      end
    end

    def has_digest_attributes # :nodoc:
      read_inheritable_attribute(:has_digest_attributes) || write_inheritable_attribute(:has_digest_attributes, {})
    end

    def dependent_has_digest_attributes # :nodoc:
      has_digest_attributes.reject { |name, options| !options.has_key?(:dependencies) }
    end

    def standalone_has_digest_attributes # :nodoc:
      has_digest_attributes.reject { |name, options| options.has_key?(:dependencies) }
    end
  end
end

ActiveRecord::Base.send(:include, HasDigest)
