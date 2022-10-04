class SessionsController < ApplicationController
  before_action :find_user_authenticated, only: %i(create)
  def new; end

  def create
    if @user&.authenticate(params[:session][:password])
      log_in @user
      if @user.admin
        redirect_to admin_root_url
      else
        redirect_back_or root_path
      end
    else
      flash.now[:error] = t "text.user_not_found"
      render :new
    end
  end

  def destroy
    log_out if logged_in?
    redirect_to root_url
  end

  private

  def find_user_authenticated
    @user = User.find_by(email: params[:session][:email].downcase)
  end
end
