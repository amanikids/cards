require 'spec_helper'

describe User do
  let 'user' do
    User.make! :password => 'password'
  end

  context 'attributes' do
    it { should allow_mass_assignment_of(:email) }
    it { should allow_mass_assignment_of(:password) }
    it { should_not allow_mass_assignment_of(:password_recovery_token) }
  end

  context 'validations' do
    it { should validate_presence_of(:email) }
    it { user; should validate_uniqueness_of(:email).case_insensitive }
  end

  context 'authenticate' do
    it 'matches email and password' do
      User.authenticate(user.email, 'password').should == user
    end

    it 'ignores email capitalization' do
      User.authenticate(user.email.swapcase, 'password').should == user
    end

    it 'fails on bad emails' do
      User.authenticate('different@example.com', 'password').should be_nil
    end

    it 'fails on bad passwords' do
      User.authenticate(user.email, 'bad password').should be_nil
    end
  end

  it 'changes the password hash when the password changes' do
    lambda { user.password = 'changed' }.should change {
      user.password_hash
    }
  end

  it 'ignores blank passwords' do
    lambda { user.password = '' }.should_not change {
      user.password_hash
    }
  end

  context 'randomize_password!' do
    it 'changes the password hash and saves the user' do
      lambda { user.randomize_password! }.should change {
        user.reload.password_hash
      }
    end
  end

  context 'save' do
    it 'changes the password recovery token' do
      lambda { user.save }.should change {
        user.password_recovery_token
      }
    end
  end
end
