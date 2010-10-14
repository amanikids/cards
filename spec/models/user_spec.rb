require 'spec_helper'

describe User do
  let!(:password) { 'secret' }
  let!(:user)     { User.make!(:password => password) }

  it { should validate_presence_of(:email) }
  it { should validate_uniqueness_of(:email).case_insensitive }

  context 'authenticate' do
    it 'matches email and password' do
      User.authenticate(user.email, password).should == user
    end

    it 'ignores email capitalization' do
      User.authenticate(user.email.swapcase, password).should == user
    end

    it 'fails on bad emails' do
      User.authenticate('different@example.com', password).should be_nil
    end

    it 'fails on bad passwords' do
      User.authenticate(user.email, 'different').should be_nil
    end
  end

  context 'create' do
    it 'randomizes the password if none is given' do
      User.create!(:email => 'bob@example.com').password_hash.should_not be_nil
    end
  end

  context 'save' do
    it 'changes the password salt when the password changes' do
      lambda { user.update_attributes(:password => 'changed') }.should change(user, :password_salt)
    end

    it 'changes the password hash when the password changes' do
      lambda { user.update_attributes(:password => 'changed') }.should change(user, :password_hash)
    end

    it 'ignores nil passwords' do
      lambda { user.update_attributes(:password => nil) }.should_not change(user, :password_hash)
    end

    it 'ignores blank passwords' do
      lambda { user.update_attributes(:password => '') }.should_not change(user, :password_hash)
    end

    it 'does not usually change the password salt' do
      lambda { user.save }.should_not change(user, :password_salt)
    end

    it 'does not usually change the password hash' do
      lambda { user.save }.should_not change(user, :password_hash)
    end

    it 'changes the password recovery token' do
      lambda { user.save }.should change(user, :password_recovery_token)
    end
  end
end
