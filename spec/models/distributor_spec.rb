require 'spec_helper'

describe Distributor do
  context 'associations' do
    it { should belong_to(:store) }
    it { should belong_to(:user) }
  end
end
