require 'spec_helper'

describe Order do
  context 'associations' do
    it { should belong_to(:cart) }
    it { should belong_to(:payment) }
  end
end
