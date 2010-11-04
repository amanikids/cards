require 'spec_helper'

describe User do
  it_behaves_like 'a model with translated attributes'

  let 'user' do
    User.make!
  end

  context 'associations' do
    it { should have_one(:administrator) }
    it { should have_many(:stores) }
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
      User.authenticate(user.email, 'secret').should == user
    end

    it 'ignores email capitalization' do
      User.authenticate(user.email.swapcase, 'secret').should == user
    end

    it 'fails on bad emails' do
      User.authenticate('different@example.com', 'secret').should be_nil
    end

    it 'fails on bad passwords' do
      User.authenticate(user.email, 'bad secret').should be_nil
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

  it 'is an administrator when associated with an Administrator' do
    expect { Administrator.make!(:user => user) }.to change {
      user.administrator?
    }
  end

  it 'is a distributor when associated with a Store' do
    lambda { Store.make!(:distributor => user) }.should change {
      user.distributor?
    }
  end
end
