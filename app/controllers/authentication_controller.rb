class AuthenticationController < ApplicationController
  def sign_up
    user = User.find_by email: params[:email]
    if user.valid_password? params[:password]
      generate_token user
      render json: {message: "Login successfully",
                    success: true, data: @data}, status: :ok
    else
      render json: {message: "Invalid email or password combination",
                    success: false}, status: :unauthorized
    end
  end

  private

  def generate_token user
    access_token = JsonWebToken.encode(user_id: user.id)
    @data = {
      access_token: access_token,
      token_type: "Bearer"
    }
  end
  
  def authenticate_user!
    token = request.headers["Authorization"].split(" ")[1]
    user_id = JsonWebToken.decode(token)["user_id"] if token
    @current_user = User.find_by id: user_id
    return if @current_user

    render json: {
      message: ["You need to log in to see the information"],
      status: 401,
      type: "failure"
    }, status: :unauthorized
  end
end