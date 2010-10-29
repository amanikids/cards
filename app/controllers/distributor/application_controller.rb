require 'concerns/current_user'

class Distributor::ApplicationController < ApplicationController
  include Concerns::CurrentUser

  private

  def require_current_user
    unless current_user
      redirect_to distributor_new_user_session_path
      return
    end

    unless current_user.distributor?
      redirect_to distributor_new_user_session_path,
        :alert => t('controllers.distributor.application_controller.distributor_required')
    end
  end
end
