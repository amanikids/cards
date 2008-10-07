module ApplicationHelper
  def render_user_partial
    if current_user
      render :partial => 'layouts/user'
    else
      render :partial => 'layouts/guest'
    end
  end
end