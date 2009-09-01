class Test::Unit::TestCase
  def self.should_observe(*names)
    names.each do |name|
      should "observe #{name}" do
        assert_contains observer.observed_classes.flatten.to_a, name.to_s.classify.constantize
      end
    end
  end

  def self.observer
    model_class.instance
  end

  def observer
    self.class.observer
  end
end