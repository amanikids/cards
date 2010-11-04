require 'concerns/current_user'

class Admin::ApplicationController < ApplicationController
  include Concerns::CurrentUser

  private

  def require_current_user
    unless current_user
      redirect_to admin_new_user_session_path
      return
    end

    unless current_user.administrator?
      redirect_to admin_new_user_session_path,
        :alert => t('controllers.admin.application_controller.administrator_required')
    end
  end
end
