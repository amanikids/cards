shared_examples_for 'a model with translated attributes' do
  RSpec::Matchers.define :have_a_translation_for do |attribute|
    match do |model_class|
      begin
        I18n.translate(attribute, :raise => true, :scope => ['activemodel', 'attributes', model_class.name.underscore])
      rescue I18n::MissingTranslationData
        false
      end
    end

    failure_message_for_should do |model_class|
      %{expected #{model_class.name} to have a translation for "#{expected}"; add one in models.attributes.en.yml}
    end
  end

  described_class.accessible_attributes.select(&:present?).each do |name|
    it { described_class.should have_a_translation_for(name) }
  end
end
