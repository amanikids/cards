require 'test_helper'

class DateInquirerTest < ActiveSupport::TestCase
  %w(monday tuesday wednesday thursday friday saturday sunday).each_with_index do |day, index|
    context "##{day}?" do
      setup do
        @date = Date.today.monday + index.days
      end

      should "be true on a #{day}" do
        @date.extend(DateInquirer).send("#{day}?").should == true
      end

      should 'be false on every other day of the week' do
        (1..6).each do |step|
          date = @date + step.days
          date.extend(DateInquirer).send("#{day}?").should == false
        end
      end
    end
  end
end