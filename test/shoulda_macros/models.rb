class Test::Unit::TestCase
  def self.should_validate_confirmation_of(*attributes)
    get_options!(attributes)
    klass = model_class

    attributes.each do |attribute|
      attribute = attribute.to_sym
      attribute_confirmation = :"#{attribute}_confirmation"

      should "require confirmation of #{attribute}" do
        model_instance = Factory.build(klass.name.underscore.to_sym)
        assert_respond_to(model_instance, :"#{attribute_confirmation}=", "#{klass.name} doesn't seem to have a #{attribute_confirmation} attribute.")
        model_instance.send(:"#{attribute_confirmation}=", model_instance.send(attribute))
        assert_bad_value(model_instance, attribute, model_instance.send(attribute).succ, :confirmation)
      end
    end
  end
end