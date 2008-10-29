module ActionView
  class Base
    def self.default_form_builder
      ::ActionView::Helpers::CustomFormBuilder
    end
  end
end