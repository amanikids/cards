require 'spec_helper'

describe Administratorship do
  context 'associations' do
    it { should belong_to(:user) }
  end
end
