class ApplicationController < ActionController::API
  include Pagy::Backend
  include SessionsHelper
  before_action :search_movies
  before_action :set_locale
  before_action :configure_permitted_parameters, if: :devise_controller?
  attr_reader :current_user
  rescue_from CanCan::AccessDenied do |_exception|
    flash[:alert] = t "access_denied"
    redirect_to root_path
  end

  # protect_from_forgery with: :exception

  def configure_permitted_parameters
    added_attrs = [:user_name, :email, :password, :password_confirmation,
                    :remember_me, :sex, :phone]
    devise_parameter_sanitizer.permit :sign_up, keys: added_attrs
    devise_parameter_sanitizer.permit :account_update, keys: added_attrs
  end

  protected
  def authenticate_request!
    unless user_id_in_token?
      render json: {errors: ["Not Authenticated"]}, status: :unauthorized
      return
    end
    @current_user = User.find auth_token[:user_id]
  rescue JWT::VerificationError, JWT::DecodeError
    render json: {errors: ["Not Authenticated"]}, status: :unauthorized
  end

  private
  def http_token
    @http_token ||= if request.headers["Authorization"].present?
                      request.headers["Authorization"].split(" ")[1]
                    end
  end

  def auth_token
    @auth_token ||= JsonWebToken.decode(http_token)
  end

  def user_id_in_token?
    http_token && auth_token && auth_token[:user_id].to_i
  end

  def set_locale
    I18n.locale = params[:locale] || I18n.default_locale
  end

  def search_movies
    binding.pry
    @q = Movie.ransack(params[:search])
    @movies = @q.result
  end
end
