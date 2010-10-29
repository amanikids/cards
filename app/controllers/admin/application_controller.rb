require 'concerns/current_user'

class Admin::ApplicationController < ApplicationController
  include Concerns::CurrentUser

  private

  def require_current_user
    redirect_to admin_new_user_session_path unless current_user
  end
end
