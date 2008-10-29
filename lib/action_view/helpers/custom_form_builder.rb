module ActionView
  module Helpers
    class CustomFormBuilder < FormBuilder
      def submit(value = "Save changes", options = {})
        super(value, options.reverse_merge(:disable_with => 'Saving...'))
      end
    end
  end
end
