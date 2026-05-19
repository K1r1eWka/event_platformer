class Api::V1::UsersController < ApplicationController
  def create
    @user = User.new(register_params)
    @user.save!
    WelcomeEmailJob.perform_later(@user.id)
    render json: @user.as_json(only: [ :email, :first_name, :last_name, :role ]), status: :created
  end

  private

  def register_params
    params.require(:user).permit(:email, :password, :first_name, :last_name, :role)
  end
end
