class Api::V1::UsersController < ApplicationController
  def create
    @user = User.create(register_params)
    if @user.persisted?
      render json: @user.as_json(only: [ :email, :first_name, :last_name, :role ]), status: :created
    else
      render json: @user.errors, status: :unprocessable_entity
    end
  end

  private

  def register_params
    params.require(:user).permit(:email, :password, :first_name, :last_name, :role)
  end
end
