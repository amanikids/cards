require 'spec_helper'

describe Payment do
  context 'associations' do
    it { should belong_to(:details) }
  end
end
