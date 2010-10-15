class UserSession
  include RSpec::Rails::Extensions::ActiveRecord::InstanceMethods
end

shared_examples_for 'an ActiveModel' do
  include ActiveModel::Lint::Tests

  before do
    @model = described_class.new
  end

  ActiveModel::Lint::Tests.public_instance_methods.grep(/^test/) do |name|
    example name.gsub('_',' ') do
      send name
    end
  end
end
