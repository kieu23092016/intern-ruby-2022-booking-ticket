class ApplicationController < ActionController::Base
  include Pagy::Backend
  include SessionsHelper

  before_action :set_locale

  rescue_from ActiveRecord::DeleteRestrictionError, with: :error_del_method
  def error_del_method
    flash[:danger] = t "not_del"
    redirect_to root_path
  end

  private

  def set_locale
    I18n.locale = params[:locale] || I18n.default_locale
  end
end
