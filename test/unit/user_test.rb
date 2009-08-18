require 'test_helper'

class UserTest < ActiveSupport::TestCase
  should_have_digest :encrypted_password, :depends => :password
  should_validate_presence_of :email, :password
  should_validate_confirmation_of :password

  context 'distributor?' do
    should 'be true for Distributor' do
      assert Factory.build(:distributor).distributor?
    end

    should 'be false for User' do
      assert !Factory.build(:user).distributor?
    end
  end

  context :validations do
    setup { Factory.create(:user) }
    should_validate_uniqueness_of :email
  end

  context :before_create do
    setup { @user = Factory.create(:user) }

    should 'write the encrypted_password' do
      assert_not_nil @user.encrypted_password
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
