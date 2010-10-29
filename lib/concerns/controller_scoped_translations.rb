module Concerns
  module ControllerScopedTranslations
    extend ActiveSupport::Concern

    included do
      alias :t :translate
      private :scope_key_by_controller
      private :translate
    end

    module InstanceMethods
      def translate(key, options={})
        super scope_key_by_controller(key), options
      end

      def scope_key_by_controller(key)
        if key.starts_with?('.')
          "controllers.#{self.class.name.underscore.tr('/', '.')}#{key}"
        else
          key
        end
      end
    end
  end
end
