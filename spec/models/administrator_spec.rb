require 'spec_helper'

describe Administrator do
  context 'associations' do
    it { should belong_to(:user) }
  end
end
