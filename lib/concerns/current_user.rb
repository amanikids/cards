module Concerns
  module CurrentUser
    extend ActiveSupport::Concern

    included do
      before_filter :require_current_user
      helper_method :current_user
      private :current_user
      private :current_user_session
    end

    module InstanceMethods
      def current_user
        @current_user ||= current_user_session.try(:user)
      end

      def current_user_session
        @current_user_session ||= UserSession.find(session)
      end
    end
  end
end
