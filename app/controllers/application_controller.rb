class ApplicationController < ActionController::Base
  include Pagy::Backend
  include SessionsHelper

  before_action :set_locale
  before_action :configure_permitted_parameters, if: :devise_controller?

  rescue_from CanCan::AccessDenied do |_exception|
    flash[:alert] = t "access_denied"
    redirect_to root_path
  end

  protect_from_forgery with: :exception

  def configure_permitted_parameters
    added_attrs = [:user_name, :email, :password, :password_confirmation,
                    :remember_me, :sex, :phone]
    devise_parameter_sanitizer.permit :sign_up, keys: added_attrs
    devise_parameter_sanitizer.permit :account_update, keys: added_attrs
  end
  private

  def set_locale
    I18n.locale = params[:locale] || I18n.default_locale
  end

  def logged_in_user
    return if user_signed_in?

    store_location
    flash[:error] = t("text.login_required")
    redirect_to login_url
  end
end
