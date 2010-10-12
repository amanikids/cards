require 'spec_helper'

describe User do
  let!(:password) { 'secret' }
  let!(:user)     { User.make!(:password => password) }

  it { should validate_presence_of(:email) }
  it { should validate_uniqueness_of(:email).case_insensitive }

  it 'authenticates by email and password' do
    User.authenticate(user.email, password).should == user
  end

  it 'authenticates by email and password, succeeding on capitalization differences' do
    User.authenticate(user.email.swapcase, password).should == user
  end

  it 'authenticates by email and password, failing on bad emails' do
    User.authenticate('different@example.com', password).should be_nil
  end

  it 'authenticates by email and password, failing on bad passwords' do
    User.authenticate(user.email, 'different').should be_nil
  end

  it 'does not change the password salt on every save' do
    lambda { user.save }.should_not change(user, :password_salt)
  end

  it 'changes the password salt when the password changes' do
    lambda { user.update_attributes(:password => 'changed') }.should change(user, :password_salt)
  end

  it 'does not change the password hash on every save' do
    lambda { user.save }.should_not change(user, :password_hash)
  end

  it 'changes the password hash when the password changes' do
    lambda { user.update_attributes(:password => 'changed') }.should change(user, :password_hash)
  end

  it 'changes the password recovery token on every save' do
    lambda { user.save }.should change(user, :password_recovery_token)
  end
end
