class ApplicationController < ActionController::Base
  include Pagy::Backend
  include SessionsHelper

  before_action :set_locale

  private

  def set_locale
    I18n.locale = params[:locale] || I18n.default_locale
  end

  def logged_in_user
    return if logged_in?

    flash[:error] = t("text.login_required")
    redirect_to login_url
  end
end
