class AdminController < ApplicationController
  before_action :require_admin

  layout "admin"

  private

  def require_admin
    return if current_user.admin?

    redirect_to root_path
  end
end
