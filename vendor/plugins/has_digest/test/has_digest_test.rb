require File.join(File.dirname(__FILE__), 'test_helper')

class HasDigestTest < Test::Unit::TestCase
  context 'Model with a standalone digest' do
    setup do
      @klass = model_with_attributes(:token) do
        has_digest :token
      end
    end

    context 'instance' do
      setup { @instance = @klass.new }

      context 'save' do
        setup { @instance.save }
        should_change('@instance.token', :to => /^\w{40}$/) { @instance.token }

        context 'save again' do
          setup { @instance.save }
          should_not_change('@instance.token') { @instance.token }
        end
      end

      should 'not rely on the default date format' do
        default = Time::DATE_FORMATS[:default]
        Time::DATE_FORMATS[:default] = '.'
        begin
          assert_unique((1..1000).collect { @instance.digest })
        ensure
          Time::DATE_FORMATS[:default] = default
        end
      end
    end
  end

  context 'Model with a single-attribute-based digest' do
    setup do
      @klass = model_with_attributes(:encrypted_password) do
        has_digest :encrypted_password, :depends => :password
      end
    end

    context 'saved instance' do
      setup { @instance = @klass.create(:password => 'PASSWORD') }

      should 'have digested attribute' do
        assert_not_nil @instance.encrypted_password
      end

      context 'saved again' do
        setup { @instance.save }
        should_not_change('@instance.encrypted_password') { @instance.encrypted_password }
      end

      context 'updated' do
        setup { @instance.update_attributes(:password => 'NEW PASSWORD') }
        should_change('@instance.encrypted_password') { @instance.encrypted_password }
      end

      context 'loaded completely fresh' do
        setup { @instance = @klass.find(@instance.id) }

        context 'and saved' do
          setup { @instance.save }
          should_not_change('@instance.encrypted_password') { @instance.encrypted_password }
        end
      end
    end
  end

  context 'Model with a multiple-attribute-based digest' do
    setup do
      @klass = model_with_attributes(:login, :remember_me_token, :remember_me_until) do
        has_digest :remember_me_token, :depends => [:login, :remember_me_until]
      end
    end

    context 'saved instance' do
      setup { @instance = @klass.create(:login => 'bob', :remember_me_until => 2.weeks.from_now) }

      should 'have digested attribute' do
        assert_not_nil @instance.remember_me_token
      end

      context 'update one attribute' do
        setup { @instance.update_attributes(:remember_me_until => 3.weeks.from_now) }
        should_change('@instance.remember_me_token') { @instance.remember_me_token }
      end

      context 'update one attribute to nil' do
        setup { @instance.update_attributes(:remember_me_until => nil) }

        should 'change digested attribute to nil' do
          assert_nil @instance.remember_me_token
        end
      end
    end
  end

  context 'Model with a magic salt column' do
    setup { @klass = model_with_attributes(:salt) }

    context 'saved instance' do
      setup { @instance = @klass.create }

      should 'not have digested salt attribute' do
        assert_nil @instance.salt
      end
    end
  end

  context 'Model with a magic salt column and an attribute-based digest' do
    setup do
      @klass = model_with_attributes(:salt, :encrypted_password) do
        has_digest :encrypted_password, :depends => :password
      end
    end

    context 'saved instance' do
      setup { @instance = @klass.create(:password => 'PASSWORD') }

      should 'have digested salt attribute' do
        assert_not_nil @instance.salt
      end

      should 'have digested encrypted_password attribute' do
        assert_not_nil @instance.encrypted_password
      end

      should 'have used salt to digest encrypted password' do
        assert_equal @instance.digest(@instance.salt, 'PASSWORD'), @instance.encrypted_password
      end
    end
  end
end
