require 'test_helper'

class UserTest < ActiveSupport::TestCase
  should_require_attributes :name, :email, :password
  should_protect_attributes :encrypted_password, :remember_me_token, :salt
  should_require_confirmation_of :email, :password

  context :validations do
    setup { Factory.create(:user) }
    should_require_unique_attributes :email
  end

  context :before_create do
    setup { @user = Factory.create(:user) }

    should 'write the encrypted_password' do
      assert_not_nil @user.encrypted_password
    end

    should 'write the remember_me_token' do
      assert_not_nil @user.remember_me_token
    end

    should 'write the salt' do
      assert_not_nil @user.salt
    end
  end

  context :authentication do
    setup { @user = Factory.create(:user) }

    should 'authenticate a user with the proper credentials' do
      assert_equal @user, User.authenticate(@user.email, @user.password)
    end

    should 'not authenticate a user with the improper email' do
      assert_nil User.authenticate('not the right email', @user.password)
    end

    should 'not authenticate a user with the improper password' do
      assert_nil User.authenticate(@user.email, 'not the right password')
    end
  end
end
