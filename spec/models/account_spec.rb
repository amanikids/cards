require 'spec_helper'

describe Account do
  let! 'paypal_account' do
    PaypalAccount.make!
  end

  let! 'justgiving_account' do
    JustgivingAccount.make!
  end

  context '.all' do
    it 'finds PayPal accounts and JustGiving accounts' do
      Account.all.should include(paypal_account, justgiving_account)
    end
  end

  context '.find' do
    it 'finds PayPal accounts by type slash id' do
      Account.find(paypal_account.type_slash_id).should == paypal_account
    end

    it 'finds JustGiving accounts by type slash id' do
      Account.find(justgiving_account.type_slash_id).should == justgiving_account
    end
  end
end
