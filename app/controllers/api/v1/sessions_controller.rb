class Api::V1::SessionsController < ApplicationController
  def create
    @user = User.find_by(email: login_params[:email])
    if @user
      if @user.authenticate(login_params[:password])
        payload = {
          user_id: @user.id,
          exp: 24.hours.from_now.to_i
        }
        jwt = JWT.encode(payload, ENV["JWT_SECRET"], "HS256")
        render json: { "jwt": jwt }
      else
        render json: { error: "invalid email or password" }, status: :unauthorized

      end
    else
      render json: { error: "invalid email or password" }, status: :unauthorized
    end
  end

  private

  def login_params
    params.require(:user).permit(:email, :password)
  end
end
