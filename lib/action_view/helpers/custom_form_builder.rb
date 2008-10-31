module ActionView
  module Helpers
    class CustomFormBuilder < FormBuilder
      def brief_error_messages
        @template.content_tag(:div, @object.errors.full_messages.to_sentence, :class => 'formErrors') if @object.errors.any?
      end

      def submit(value = "Save changes", options = {})
        super(value, options.reverse_merge(:disable_with => 'Saving...'))
      end
    end
  end
end
