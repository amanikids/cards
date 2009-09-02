class Test::Unit::TestCase
  def self.should_validate_confirmation_of(*attributes)
    get_options!(attributes)

    attributes.each do |attribute|
      attribute = attribute.to_sym
      attribute_confirmation = :"#{attribute}_confirmation"

      should "require confirmation of #{attribute}" do
        # subject returns a new instance each time, but we need to modify it a little bit
        object = subject

        assert_respond_to(object, :"#{attribute_confirmation}=", "#{subject.class} doesn't seem to have a #{attribute_confirmation} attribute.")
        object.send(:"#{attribute_confirmation}=", 'anything to trigger the validation')
        assert_good_value(object, attribute, 'anything to trigger the validation', :confirmation)
        assert_bad_value(object, attribute, 'something different', :confirmation)
      end
    end
  end
end