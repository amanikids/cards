require 'spec_helper'

describe UserSession do
  let(:user_session) { UserSession.new(session, credentials) }
  let(:credentials)  { { :email => 'bob@example.com', :password => 'secret' } }
  let(:user)         { mock_model(User) }
  let(:session)      { { :user_id => 42 } }

  it 'finds users by session ids' do
    User.should_receive(:find).with(42).and_return(user)
    UserSession.find(session).user.should == user
  end

  it 'returns nil if user is not found' do
    User.stub(:find).and_raise(ActiveRecord::RecordNotFound)
    UserSession.find(session).should be_nil
  end

  it 'returns truthy when built with a user' do
    UserSession.new(session, user).save.should be_true
  end

  it 'does not try to authenticate if email is blank' do
    User.should_not_receive(:authenticate)
    user_session.email = ''
    user_session.save
  end

  it 'returns falsey if email is blank' do
    user_session.email = ''
    user_session.save.should be_false
  end

  it 'shows a validation error if email is blank' do
    user_session.email = ''
    user_session.should have(1).error_on(:email)
  end

  it 'does not try to authenticate if password is blank' do
    User.should_not_receive(:authenticate)
    user_session.password = ''
    user_session.save
  end

  it 'returns falsey if password is blank' do
    user_session.password = ''
    user_session.save.should be_false
  end

  it 'shows a validation error if password is blank' do
    user_session.password = ''
    user_session.should have(1).error_on(:password)
  end

  it 'returns falsey for a failed authentication' do
    User.should_receive(:authenticate).and_return(nil)
    user_session.save.should be_false
  end

  it 'shows a validation error for a failed authentication' do
    User.should_receive(:authenticate).and_return(nil)
    user_session.should have(1).error_on(:base)
  end

  it 'returns truthy for a successful authentication' do
    User.should_receive(:authenticate).and_return(user)
    user_session.save.should be_true
  end

  it 'puts the user id in the session for a successful authentication' do
    User.should_receive(:authenticate).and_return(user)
    user_session.save
    session[:user_id].should == user.id
  end

  it 'removes the user id from the session on destroy' do
    user_session = UserSession.new(session, user)
    user_session.save
    user_session.destroy
    session[:user_id].should be_nil
  end
end
