class Test::Unit::TestCase
  def self.should_observe(*names)
    names.each do |name|
      should "observe #{name}" do
        assert_contains subject.observed_classes.flatten.to_a, name.to_s.classify.constantize
      end
    end
  end
end